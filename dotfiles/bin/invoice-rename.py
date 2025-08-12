#!/usr/bin/env uv run --script
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "loguru",
#     "pdfplumber",
# ]
# ///

import pdfplumber as pp
from math import isclose, sqrt
from dataclasses import dataclass
from textwrap import shorten as shorten_text
from typing import Union
from argparse import ArgumentParser
from enum import StrEnum
from copy import copy
from pprint import pprint
from typing import Optional
import datetime as dt
import re
from loguru import logger


GERMAN_DATE_REGEX: str = r"(?P<day>\d{1,2})\.(?P<month>\d{1,2})\.(?P<year>\d{4})"
ISO_DATE_REGEX: str = r"(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})"
AMERICAN_DATE_LONG: str = r"(?P<month>\w+) (?P<day>\d{1,2}), (?P<year>\d{4})"

MONTH_MAP = [
    re.compile("jan", re.IGNORECASE),
    re.compile("feb", re.IGNORECASE),
    re.compile("mar", re.IGNORECASE),
    re.compile("m[äa]r", re.IGNORECASE),
    re.compile("apr", re.IGNORECASE),
    re.compile("ma[iy]", re.IGNORECASE),
    re.compile("jun", re.IGNORECASE),
    re.compile("jul", re.IGNORECASE),
    re.compile("aug", re.IGNORECASE),
    re.compile("sep", re.IGNORECASE),
    re.compile("o[ck]t", re.IGNORECASE),
    re.compile("nov", re.IGNORECASE),
    re.compile("de[cz]", re.IGNORECASE),
]


def to_month(val: str) -> None | int:
    try:
        logger.debug("Converting to int: {}", val)
        val = int(val)
        return val
    except ValueError:
        pass
    val = val.lower()
    for month, matcher in enumerate(MONTH_MAP, start=1):
        logger.trace("... trying to match '{}'", matcher.pattern)
        if matcher.fullmatch(val[:3]):
            logger.debug("... got month '{}'", month)
            return month
    return None


@dataclass
class Point:
    x: float
    y: float

    @property
    def tuple(self):
        return (self.x, self.y)

    def distance(self, other) -> float:
        return sqrt(
            (self.top_left.x - other.top_left.x)
            ^ 2 + (self.top_left.y - other.top_left.y)
            ^ 2
        )

    def __mod__(self, other):
        """Modulo-operator does the same as distance()."""
        return self.distance(other)

    def __str__(self):
        return f"({self.x:.02f}, {self.y:.02f})"


@dataclass
class WordWrapper:
    w: dict

    @property
    def page_number(self) -> int:
        """Page number on which this character was found."""
        return self.w["page_number"]

    @property
    def text(self) -> str:
        """E.g., "z", or "Z" or " "."""
        return self.w["text"]

    @property
    def fontname(self) -> str:
        """Name of the character's font face."""
        return self.w["fontname"]

    @property
    def size(self) -> float:
        """Font size."""
        return self.w["size"]

    @property
    def adv(self) -> float:
        """Equal to text width * the font size * scaling factor."""
        return self.w["adv"]

    @property
    def upright(self) -> bool:
        """Whether the character is upright."""
        return self.w["upright"]

    @property
    def height(self) -> float:
        """Height of the character."""
        return self.w["height"]

    @property
    def width(self) -> float:
        """Width of the character."""
        return self.w["width"]

    @property
    def x0(self) -> float:
        """Distance of left side of character from left side of page."""
        return self.w["x0"]

    @property
    def x1(self) -> float:
        """Distance of right side of character from left side of page."""
        return self.w["x1"]

    @property
    def y0(self) -> float:
        """Distance of bottom of character from bottom of page."""
        return self.w["y0"]

    @property
    def y1(self) -> float:
        """Distance of top of character from bottom of page."""
        return self.w["y1"]

    @property
    def top(self) -> float:
        """Distance of top of character from top of page."""
        return self.w["top"]

    @property
    def bottom(self) -> float:
        """Distance of bottom of the character from top of page."""
        return self.w["bottom"]

    @property
    def doctop(self) -> float:
        """Distance of top of character from top of document."""
        return self.w["doctop"]

    @property
    def matrix(self):
        """The "current transformation matrix" for this character. (See below for details.)"""
        return self.w["matrix"]

    @property
    def mcid(self):
        """The marked content section ID for this character if any (otherwise None). Experimental attribute."""
        return self.w["mcid"]

    @property
    def tag(self):
        """The marked content section tag for this character if any (otherwise None). Experimental attribute."""
        return self.w["tag"]

    @property
    def ncs(self):
        """TKTK"""
        return self.w["ncs"]

    @property
    def stroking_pattern(self):
        """TKTK"""
        return self.w["stroking_pattern"]

    @property
    def non_stroking_pattern(self):
        """TKTK"""
        return self.w["non_stroking_pattern"]

    @property
    def stroking_color(self):
        """The color of the character's outline (i.e., stroke). See docs/colors.md for details."""
        return self.w["stroking_color"]

    @property
    def non_stroking_color(self):
        """The character's interior color. See docs/colors.md for details."""
        return self.w["non_stroking_color"]

    @property
    def object_type(self) -> str:
        """\"char\" """
        return self.w["object_type"]

    @property
    def top_left(self) -> Point:
        return Point(self.x0, self.top)

    @property
    def bottom_right(self) -> Point:
        return Point(self.x0, self.top)

    def diff(self, other) -> tuple[float, float]:
        """returns absolute y-position  and height difference in that order"""
        ydiff = abs(self.bottom - other.bottom)
        hdiff = abs(self.height - other.height)
        return ydiff, hdiff

    def __eq__(self, other: Union["WordWrapper", dict]) -> bool:
        """Returns the distance between the two top-left corners of the given words"""
        other = self.__class__.get(other)
        return self.w == other.w

    def __mod__(self, other: Union["WordWrapper", dict]) -> bool:
        """Returns the distance between the two top-left corners of the given words"""
        other = other if not isinstance(other, dict) else self.__class__(other)
        return sqrt((self.x0 - other.x0) ^ 2 + (self.top - other.top) ^ 2)

    @classmethod
    def get(cls, thing: Union["Wordwrapper", dict]) -> "WordWrapper":
        return cls(thing) if isinstance(thing, dict) else thing

    @staticmethod
    def unget(thing: Union["Wordwrapper", dict]) -> dict:
        return thing if isinstance(thing, dict) else thing.w


@dataclass
class Line:
    # all relative to PAGE ...
    top_left: Point
    bottom_right: Point
    words: list[dict]
    text: str

    @classmethod
    def from_words(cls, line_words: list[dict | WordWrapper]) -> "Line":
        line_words = [WordWrapper.unget(word) for word in line_words]
        top = min(word["top"] for word in line_words)
        left = min(word["x0"] for word in line_words)
        bottom = max(word["bottom"] for word in line_words)
        right = max(word["x1"] for word in line_words)
        text = " ".join(word["text"] for word in line_words)
        line = cls(Point(top, left), Point(bottom, right), line_words, text)
        return line

    @property
    def height(self) -> float:
        return self.top_left.y - self.bottom_right.y

    @property
    def width(self) -> float:
        return self.bottom_right.x - self.top_left.x

    @property
    def top(self) -> float:
        return self.top_left.y

    @property
    def bottom(self) -> float:
        return self.bottom_right.y

    @property
    def left(self) -> float:
        return self.top_left.x

    @property
    def right(self) -> float:
        return self.bottom_right.x

    def __str__(self):
        return self.text

    def __repr__(self):
        return f"Line({self.top_left!s},{self.bottom_right!s}, '{shorten_text(self.text, 50).replace("'", "''")}')"

    def __eq__(self, other):
        return all(
            [
                isclose(self.top_left.x, other.top_left.x, rel_tol=0.00075),
                isclose(self.top_left.x, other.top_left.x, rel_tol=0.00075),
                isclose(self.bottom_right.x, other.bottom_right.x, rel_tol=0.00075),
                isclose(self.top_left.x, other.top_left_x, rel_tol=0.00075),
                self.text == other.text,
            ]
        )

    @classmethod
    def page_lines(
        cls,
        page_words: list[dict | WordWrapper],
        # yt/ht_abs/rel: tolerance for y and height difference
        yt_abs=None,
        yt_rel=None,  # will be converted to "abs" by using yt_rel * word_height
        ht_abs=None,
        ht_rel=None,  # will be converted to "abs" by using yt_rel * word_height
    ) -> list["Line"]:
        """Returns a line and a list of 'unused' words (words not present in line)."""
        page_words: list[WordWrapper] = [WordWrapper.get(word) for word in page_words]
        # sort top-to-bottom, left-to-right
        page_words: list[WordWrapper] = sorted(
            page_words, key=lambda x: tuple(reversed(x.top_left.tuple))
        )
        unused_words: list[WordWrapper] = page_words
        page_lines: list[Line] = []
        while unused_words:
            reference_word: WordWrapper = unused_words[0]
            line_words: list[WordWrapper] = [reference_word]
            new_unused: list[WordWrapper] = []
            # char/word properties: https://is.gd/ehF1Q3
            yt_abs: float = yt_abs or (yt_rel or 0.01) * reference_word.height
            ht_abs: float = ht_abs or (ht_rel or 0.02) * reference_word.height
            page_words = [word for word in page_words if word != reference_word]
            for word in unused_words[1:]:
                ydiff, hdiff = reference_word.diff(word)
                height_check: bool = abs(word.height - reference_word.height) <= ht_abs
                axis_check: bool = abs(word.bottom - reference_word.bottom) <= yt_abs
                checks_passed: bool = height_check and axis_check
                if checks_passed:
                    line_words.append(word)
                else:
                    new_unused.append(word)
            page_lines.append(cls.from_words(line_words))
            unused_words = new_unused
        return page_lines


class Direction(StrEnum):
    up = "up"
    down = "down"


class InvoiceExtractor:
    _extractors: list["InvoiceExtractor"] = []

    # CLASS vars

    markers: list[str] = []
    lines: list[Line]

    vendor: str

    date_format: str = "%Y-%m-%d"
    date_marker: str
    date_direction: Direction
    date_regex: str

    invoice_number_marker: str
    invoice_number_regex: str
    invoice_number_direction: str
    invoice_number_brackets: str = "[]"

    table_marker: str
    table_header_lines: int = 1

    sum_marker: str
    sum_regex: str

    final_name: list[str] = ["%DATE", "%WHAT", "%INVOICE_NUMBER"]

    # INSTANCE vars

    _lines: list[Line]
    _date: dt.date
    _invoice_number: str

    def __init_subclass__(cls, *args, **kwargs):
        super().__init_subclass__(*args, **kwargs)
        cls._extractors.append(cls)

    def __init__(self, lines: list[Line]):
        self._lines = lines
        self._date = None
        self._invoice_number = None
        self.__post_init__()

    def __post_init__(self): ...

    @classmethod
    def can_handle(cls, lines: list[Line]) -> Optional["InvoiceExtractor"]:
        found_markers = 0
        for marker in cls.markers:
            for line in lines:
                if line.text.find(marker) > -1:
                    found_markers += 1
                    break
        if found_markers == len(cls.markers):
            return cls(lines)
        return None

    @classmethod
    def get_for(cls, lines: list[Line]) -> Union[None, "InvoiceExtractor"]:
        for extractor_cls in cls._extractors:
            extractor = extractor_cls.can_handle(lines)
            if extractor:
                return extractor
        return None

    def _get_from_marker(self, marker_str, value_regex):
        marker_str = marker_str.lower()
        logger.debug("Checking for '{}'", marker_str)
        for line in self._lines:
            text = line.text.lower()
            if text.find(marker_str) > -1:
                logger.debug("Found in line: '{}'", line.text)
                # do NOT lower for the final extraction ...
                match = re.search(value_regex, line.text)
                if match:
                    return match
        return None

    @property
    def date(self) -> dt.datetime:
        if not self._date:
            match = self._get_from_marker(self.date_marker, self.date_regex)
            if match:
                logger.debug("Have date match: {}", match.groups())
                year = int(match.group("year"))
                month = to_month(match.group("month"))
                day = int(match.group("day"))
                self._date = dt.date(year, month, day)
        return self._date

    @property
    def invoice_number(self) -> dt.datetime:
        if not self._invoice_number:
            match = self._get_from_marker(
                self.invoice_number_marker, self.invoice_number_regex
            )
            if match:
                self._invoice_number = match.group(1)
        return self._invoice_number

    @property
    def date_str(self):
        return self.date.strftime(self.date_format)


class AmazonInvoice(InvoiceExtractor):
    markers: list[str] = ["Umsatzsteuer erklärt durch Amazon"]
    date_marker: str = "/Lieferdatum"
    date_regex: str = GERMAN_DATE_REGEX
    invoice_number_marker = "Rechnungsnummer"
    invoice_number_regex = r" ([\w_-]+)"
    table_marker: str = "Menge Stückpreis USt. %"
    table_header_lines: int = 2
    vendor: str = "Amazon"


class AnthropicInvoice(InvoiceExtractor):
    markers: list[str] = ["Anthropic, PBC"]
    table_marker: str = "Description"
    date_marker: str = "Date of issue"
    date_regex: str = AMERICAN_DATE_LONG
    invoice_number_marker = "Invoice number"
    invoice_number_regex = r": (\w+-\d+)"
    vendor = "Anthropic"

    def __post_init__(self):
        for line in self._lines:
            line.text = line.text.replace("\x00", "-")


class HexonetInvoice(InvoiceExtractor):
    markers: list[str] = ["Key-Systems GmbH, Kaiserstraße"]
    table_marker: str = "Pos Beschreibung"
    date_marker: str = "Rechnung"  # yup, really ... sucks ...
    date_regex: str = ISO_DATE_REGEX
    invoice_number_marker = "Rechnung:"
    invoice_number_regex = r": ([\w_-]+)"
    vendor = "Hexonet"


class WasabiInvoice(InvoiceExtractor):
    markers: list[str] = ["Key-Systems GmbH, Kaiserstraße"]
    table_marker: str = "Pos Beschreibung"
    date_marker: str = "Rechnung"  # yup, really ... sucks ...
    date_regex: str = ISO_DATE_REGEX
    invoice_number_marker = "Rechnung:"
    invoice_number_regex = r": ([\w_-]+)"


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("pdf_files", nargs="+", metavar="PDF_FILE")
    config = parser.parse_args()

    for pdf_file in config.pdf_files:
        with pp.open(pdf_file) as pdf:
            for page in pdf.pages:
                page_words: list[dict] = page.extract_words()
                break

        lines = Line.page_lines(page_words)
        extractor = InvoiceExtractor.get_for(lines)
        pprint([line.text for line in lines])
        print(f"Extractor:      {extractor}")
        print(f"File:           {pdf_file}")
        print(f"Invoice date:   {extractor.date_str}")
        print(f"Invoice number: {extractor.invoice_number}")
