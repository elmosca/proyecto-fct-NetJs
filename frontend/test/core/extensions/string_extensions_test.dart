import 'package:flutter_test/flutter_test.dart';
import 'package:fct_frontend/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions Tests', () {
    group('capitalize', () {
      test('should capitalize first letter of each word', () {
        expect('hello world'.capitalize, equals('Hello World'));
        expect('flutter dart'.capitalize, equals('Flutter Dart'));
        expect('FCT PROJECT'.capitalize, equals('Fct Project'));
      });

      test('should handle empty string', () {
        expect(''.capitalize, equals(''));
      });

      test('should handle single word', () {
        expect('hello'.capitalize, equals('Hello'));
        expect('WORLD'.capitalize, equals('World'));
      });
    });

    group('isEmail', () {
      test('should return true for valid emails', () {
        expect('test@example.com'.isEmail, isTrue);
        expect('user.name@domain.co.uk'.isEmail, isTrue);
        expect('user+tag@example.org'.isEmail, isTrue);
      });

      test('should return false for invalid emails', () {
        expect('invalid-email'.isEmail, isFalse);
        expect('@example.com'.isEmail, isFalse);
        expect('user@'.isEmail, isFalse);
        expect(''.isEmail, isFalse);
      });
    });

    group('isUrl', () {
      test('should return true for valid URLs', () {
        expect('https://example.com'.isUrl, isTrue);
        expect('http://localhost:3000'.isUrl, isTrue);
        expect('https://api.example.com/v1'.isUrl, isTrue);
      });

      test('should return false for invalid URLs', () {
        expect('not-a-url'.isUrl, isFalse);
        expect('ftp://invalid'.isUrl, isFalse);
        expect(''.isUrl, isFalse);
      });
    });

    group('truncate', () {
      test('should truncate long strings', () {
        expect('Hello World'.truncate(5), equals('Hello...'));
        expect('Flutter is amazing'.truncate(10), equals('Flutter is...'));
      });

      test('should not truncate short strings', () {
        expect('Hello'.truncate(10), equals('Hello'));
        expect('Short'.truncate(5), equals('Short'));
      });

      test('should use custom suffix', () {
        expect('Hello World'.truncate(5, suffix: '***'), equals('Hello***'));
      });
    });

    group('toSlug', () {
      test('should convert to URL-friendly slug', () {
        expect('Hello World'.toSlug, equals('hello-world'));
        expect('Flutter & Dart!'.toSlug, equals('flutter-dart'));
        expect('Multiple   Spaces'.toSlug, equals('multiple-spaces'));
        expect('Special@Characters#'.toSlug, equals('specialcharacters'));
      });

      test('should handle empty string', () {
        expect(''.toSlug, equals(''));
      });

      test('should handle special characters', () {
        expect('áéíóú'.toSlug, equals('áéíóú'));
        expect('ñÑ'.toSlug, equals('ññ'));
      });
    });
  });
}
