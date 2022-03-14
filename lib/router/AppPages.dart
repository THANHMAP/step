import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:step_bank/screens/education/detail_topic_education.dart';
import 'package:step_bank/screens/forgotpassword/forgotpassowrd_screen.dart';
import 'package:step_bank/screens/forgotpassword/input_old_password.dart';
import 'package:step_bank/screens/home/home_main.dart';
import 'package:step_bank/screens/login/login_screen.dart';
import 'package:step_bank/screens/news/news_detail_screen.dart';
import 'package:step_bank/screens/news/news_screen.dart';
import 'package:step_bank/screens/otp/otp_screen.dart';
import 'package:step_bank/screens/quizz/home_quizz.dart';
import 'package:step_bank/screens/quizz/quizz.dart';
import 'package:step_bank/screens/register/register_screen.dart';
import 'package:step_bank/screens/setting/faq.dart';
import 'package:step_bank/screens/setting/report_error.dart';
import 'package:step_bank/screens/setting/setup_account.dart';
import 'package:step_bank/screens/setting/user_account.dart';
import 'package:step_bank/screens/splash/splash.dart';
import 'package:step_bank/screens/test.dart';
import 'package:step_bank/screens/updatepassword/update_password_screen.dart';

import '../screens/dashboard/education.dart';
import '../screens/education/detail_study.dart';
import '../screens/education/topic_education.dart';
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
      transition: Transition.rightToLeft,
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPassWordScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.updatePassword,
      page: () => const UpdatePassWordScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeMain(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.news,
      page: () => const NewsScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.newsDetail,
      page: () => const NewsDetailScreen(newsData: null,),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.editProfile,
      page: () => const AccountScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.reportError,
      page: () => const ReportScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.faq,
      page: () => const FAQScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.setupAccount,
      page: () => const AccountSetupScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.inputAccountAgain,
      page: () => const InputOldPassWordScreen(),
    ),
    GetPage(
      name: AppRoutes.education,
      page: () => const EducationScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.educationTopic,
      page: () => const TopicEducationScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.educationTopicDetail,
      page: () => const DetailEducationScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.detailEducationScreen,
      page: () => const DetailEducationLessonScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.homeQuizScreen,
      page: () => const HomeQuizScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.quizScreen,
      page: () => const QuizScreen(),
    ),
  ];
}
