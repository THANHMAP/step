import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:step_bank/screens/dashboard/tool.dart';
import 'package:step_bank/screens/education/detail_topic_education.dart';
import 'package:step_bank/screens/education/video.dart';
import 'package:step_bank/screens/forgotpassword/forgotpassowrd_screen.dart';
import 'package:step_bank/screens/forgotpassword/input_old_password.dart';
import 'package:step_bank/screens/home/home_main.dart';
import 'package:step_bank/screens/login/login_screen.dart';
import 'package:step_bank/screens/news/news_detail_screen.dart';
import 'package:step_bank/screens/news/news_screen.dart';
import 'package:step_bank/screens/otp/otp_screen.dart';
import 'package:step_bank/screens/quizz/home_quizz.dart';
import 'package:step_bank/screens/quizz/quizz.dart';
import 'package:step_bank/screens/quizz/result.dart';
import 'package:step_bank/screens/quizz/show_quiz.dart';
import 'package:step_bank/screens/register/register_screen.dart';
import 'package:step_bank/screens/setting/faq.dart';
import 'package:step_bank/screens/setting/leader_board.dart';
import 'package:step_bank/screens/setting/report_error.dart';
import 'package:step_bank/screens/setting/setup_account.dart';
import 'package:step_bank/screens/setting/user_account.dart';
import 'package:step_bank/screens/splash/splash.dart';
import 'package:step_bank/screens/test.dart';
import 'package:step_bank/screens/tool/budget/calculator_budget.dart';
import 'package:step_bank/screens/tool/budget/edit_budget.dart';
import 'package:step_bank/screens/tool/introduction_tool.dart';
import 'package:step_bank/screens/tool/budget/tool_set_budget.dart';
import 'package:step_bank/screens/tool/loan/add_loan.dart';
import 'package:step_bank/screens/tool/loan/edit_loan.dart';
import 'package:step_bank/screens/tool/loan/portfolio_of_loan.dart';
import 'package:step_bank/screens/updatepassword/update_password_screen.dart';

import '../screens/dashboard/education.dart';
import '../screens/education/course_screen.dart';
import '../screens/education/detail_study.dart';
import '../screens/education/topic_education.dart';
import '../screens/quizz/quiz_custom.dart';
import '../screens/tool/budget/detail_budget.dart';
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
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.resultQuizScreen,
      page: () => const ResultQuizScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.courseScreen,
      page: () => const CourseScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.videoScreen,
      page: () => const VideoScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.quizCustomScreen,
      page: () => const QuizCustomScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.toolScreen,
      page: () => const ToolScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.leaderBoardScreen,
      page: () => const LeaderBoardScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.showQuizScreen,
      page: () => const ShowQuizScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.introductionToolScreen,
      page: () => const IntroductionToolScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.toolBudgetScreen,
      page: () => const ToolBudgetScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.detailBudgetScreen,
      page: () => const DetailBudgetScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.calculatorBudgetScreen,
      page: () => const CalculatorBudgetScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.portfolioOfLoanScreen,
      page: () => const PortfolioOfLoanScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.addLoanScreen,
      page: () => const AddLoanScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.editLoanScreen,
      page: () => const EditLoanScreen(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: AppRoutes.editBudgetScreen,
      page: () => const EditBudgetScreen(),
    ),
  ];
}
