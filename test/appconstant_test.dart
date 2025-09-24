import 'package:eventmanagement/screens/eventchatscreen/appconstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('AppConstants Tests', () {
    test('Publishable and Secret Keys should not be empty', () {
      expect(publishableKey.isNotEmpty, true);
      expect(secretKey.isNotEmpty, true);
    });

    test('AppColors should return correct color values', () {
      expect(AppColors.black, const Color(0xff262628));
      expect(AppColors.white, const Color(0xffFFFFFF));
      expect(AppColors.blue, const Color(0xff274560));
      expect(AppColors.textFieldBackground, const Color(0xffE5E5E5));
      expect(AppColors.genderTextColor, const Color(0xffA6A6A6));
      expect(AppColors.border, const Color(0xffC4C4C4));
      expect(AppColors.white2, const Color(0xffEEEEEE));
      expect(AppColors.circle, const Color(0xffE2E2E2));
      expect(AppColors.whitegrey, const Color(0xffC3C2C2));
      expect(AppColors.grey, const Color(0xff918F8F));
      expect(AppColors.greychat, const Color(0xffE8E8E8));
    });
  });
}
