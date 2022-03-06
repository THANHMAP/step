import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:step_bank/screens/forgotpassword/forgotpassowrd_screen.dart';
import 'package:step_bank/screens/home/home_main.dart';
import 'package:step_bank/screens/login/login_screen.dart';
import 'package:step_bank/screens/news/news_detail_screen.dart';
import 'package:step_bank/screens/news/news_screen.dart';
import 'package:step_bank/screens/otp/otp_screen.dart';
import 'package:step_bank/screens/register/register_screen.dart';
import 'package:step_bank/screens/setting/user_account.dart';
import 'package:step_bank/screens/splash/splash.dart';
import 'package:step_bank/screens/test.dart';
import 'package:step_bank/screens/updatepassword/update_password_screen.dart';

import 'app_router.dart';

class AppPages {
  static var listPage = [
    GetPage(
      name: AppRoutes.test,
      page: () => const TestScreen(),
    ),
    GetPage(
      name: AppRoutes.intro,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPassWordScreen(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: AppRoutes.updatePassword,
      page: () => const UpdatePassWordScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeMain(),
    ),
    GetPage(
      name: AppRoutes.news,
      page: () => const NewsScreen(),
    ),
    GetPage(
      name: AppRoutes.newsDetail,
      page: () => const NewsDetailScreen(newsData: null,),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const AccountScreen(),
    ),
  ];
}
