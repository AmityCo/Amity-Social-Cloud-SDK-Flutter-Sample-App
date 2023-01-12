library dynamic_text_highlighting;

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DynamicTextHighlighting extends StatelessWidget {
  //DynamicTextHighlighting
  final String text;
  final List<String> highlights;
  final Color color;
  final TextStyle style;
  final bool caseSensitive;
  final ValueChanged<String> onHighlightClick;

  //RichText
  // final TextAlign textAlign;
  // final TextDirection textDirection;
  // final bool softWrap;
  // final TextOverflow overflow;
  // final double textScaleFactor;
  // final int maxLines;
  // final Locale locale;
  // final StrutStyle strutStyle;
  // final TextWidthBasis textWidthBasis;
  // final TextHeightBehavior textHeightBehavior;

  const DynamicTextHighlighting({
    //DynamicTextHighlighting
    Key? key,
    required this.text,
    required this.highlights,
    this.color = Colors.blue,
    this.style = const TextStyle(
      color: Colors.black,
    ),
    this.caseSensitive = true,
    required this.onHighlightClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Controls
    if (text == '') {
      return _richText(_normalSpan(text));
    }
    if (highlights.isEmpty) {
      return _richText(_normalSpan(text));
    }
    for (int i = 0; i < highlights.length; i++) {
      if (highlights[i] == null) {
        assert(highlights[i] != null);
        return _richText(_normalSpan(text));
      }
      if (highlights[i].isEmpty) {
        assert(highlights[i].isNotEmpty);
        return _richText(_normalSpan(text));
      }
    }

    //Main code
    List<TextSpan> spans = [];
    int start = 0;

    //For "No Case Sensitive" option
    String lowerCaseText = text.toLowerCase();
    List<String> lowerCaseHighlights = [];

    highlights.forEach((element) {
      lowerCaseHighlights.add(element.toLowerCase());
    });

    while (true) {
      Map<int, String> highlightsMap = {}; //key (index), value (highlight).

      if (caseSensitive) {
        for (int i = 0; i < highlights.length; i++) {
          int index = text.indexOf(highlights[i], start);
          if (index >= 0) {
            highlightsMap.putIfAbsent(index, () => highlights[i]);
          }
        }
      } else {
        for (int i = 0; i < highlights.length; i++) {
          int index = lowerCaseText.indexOf(lowerCaseHighlights[i], start);
          if (index >= 0) {
            highlightsMap.putIfAbsent(index, () => highlights[i]);
          }
        }
      }

      if (highlightsMap.isNotEmpty) {
        List<int> indexes = [];
        highlightsMap.forEach((key, value) => indexes.add(key));

        int currentIndex = indexes.reduce(min);
        String currentHighlight = text.substring(
            currentIndex, currentIndex + highlightsMap[currentIndex]!.length);

        if (currentIndex == start) {
          spans.add(_highlightSpan(currentHighlight));
          start += currentHighlight.length;
        } else {
          spans.add(_normalSpan(text.substring(start, currentIndex)));
          spans.add(_highlightSpan(currentHighlight));
          start = currentIndex + currentHighlight.length;
        }
      } else {
        spans.add(_normalSpan(text.substring(start, text.length)));
        break;
      }
    }

    return _richText(TextSpan(children: spans));
  }

  TextSpan _highlightSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onHighlightClick(value);
          },
      );
    } else {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onHighlightClick(value);
          },
      );
    }
  }

  TextSpan _normalSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: Colors.black,
        ),
      );
    } else {
      return TextSpan(
        text: value,
        style: style,
      );
    }
  }

  RichText _richText(TextSpan text) {
    return RichText(
      key: key,
      text: text,
      // textAlign: textAlign,
      // textDirection: textDirection,
      // softWrap: softWrap,
      // overflow: overflow,
      // textScaleFactor: textScaleFactor,
      // maxLines: maxLines,
      // locale: locale,
      // strutStyle: strutStyle,
      // textWidthBasis: textWidthBasis,
      // textHeightBehavior: textHeightBehavior,
    );
  }
}
