import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import "package:markdown/markdown.dart" as md show Text;

class MathBuilder extends MarkdownElementBuilder {


  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    String tex = text.toString().trim();

    // 块级公式 $$...$$
    if (tex.startsWith(r'$$') && tex.endsWith(r'$$')) {
      tex = tex.substring(2, tex.length - 2);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Math.tex(
            tex,
            mathStyle: MathStyle.display,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    // 行内公式 $...$
    else if (tex.startsWith(r'$') && tex.endsWith(r'$')) {
      tex = tex.substring(1, tex.length - 1);
      return Math.tex(
        tex,
        mathStyle: MathStyle.text,
        textStyle: const TextStyle(fontSize: 16),
      );
    }
    // 普通文本
    return Text(tex, style: preferredStyle);
  }
}