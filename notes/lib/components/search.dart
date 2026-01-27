import 'package:flutter/material.dart';

TextSpan highlightOccurrences(String source, String query) {
  if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
    return TextSpan(
      text: source, 
      style: const TextStyle(color: Colors.black, fontSize: 16) 
    );
  }

  final matches = query.toLowerCase().allMatches(source.toLowerCase());
  int lastMatchEnd = 0;
  final children = <TextSpan>[];

  for (final match in matches) {
    if (match.start > lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
        style: const TextStyle(color: Colors.black) 
      ));
    }
    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: const TextStyle(
        backgroundColor: Colors.yellow, 
        fontWeight: FontWeight.bold,
        color: Colors.black 
      ),
    ));
    lastMatchEnd = match.end;
  }
  
  if (lastMatchEnd < source.length) {
    children.add(TextSpan(
      text: source.substring(lastMatchEnd),
      style: const TextStyle(color: Colors.black)
    ));
  }

  return TextSpan(children: children, style: const TextStyle(color: Colors.black, fontSize: 16));
}