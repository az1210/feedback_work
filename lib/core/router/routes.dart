import 'package:feedback_work/core/router/navbar.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/screens/feedback/provide/preview_set_screen.dart';
import 'package:feedback_work/screens/feedback/provide/provide_feedback_screen.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/set_feedback_model.dart';
import 'package:feedback_work/screens/user/screens/add_child_screen.dart';
import 'package:feedback_work/screens/user/screens/add_parent_screen.dart';
import 'package:feedback_work/screens/user/screens/edit_profile_screen.dart';
import 'package:feedback_work/screens/user/screens/feedback_receipt_screen.dart';
import 'package:feedback_work/screens/user/screens/parent_and_children_screen.dart';
import 'package:feedback_work/screens/user/screens/profile_screen.dart';
import 'package:feedback_work/screens/feedback/received_feedback_details.dart';
import 'package:feedback_work/screens/feedback/request/request_feedback_screen.dart';
import 'package:feedback_work/screens/groups/groups_screen.dart';
import 'package:feedback_work/screens/groups/monitor_group_screen.dart';
import 'package:feedback_work/screens/network/network_profile_screen.dart';
import 'package:feedback_work/screens/network/network_screen.dart';
import 'package:feedback_work/screens/status/status_report_screen.dart';
import 'package:feedback_work/screens/user/screens/transaction_history.dart';
import 'package:feedback_work/screens/user/screens/transaction_history_details_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/onboard/splash_screen.dart';
import '../../screens/onboard/onboard_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/complete_profile_screen.dart';
import '../../screens/projects/projects_screen.dart';
import '../../screens/projects/create_project_screen.dart';
import '../../screens/projects/project_edit_screen.dart';
import '../../screens/auth/forgot_pass_screen.dart';
import '../../screens/feedback/feedback_screen.dart';
import '../../screens/status/status_screen.dart';
import '../../screens/more/more_drawer.dart';
import '../../screens/projects/solution_function.dart';
import '../../screens/projects/settings_screen.dart';

extension Convert on String {
  String get p => '/$this';
}

class Routes {
  Routes._();

  static const splash = '/';
  static const onboarding = 'onboarding';
  static const signUp = 'sign-up';
  static const signIn = 'sign-in';
  static const forgotPassword = 'forgot-password';
  static const completeProfile = 'complete-profile';
  static const projects = 'projects';
  static const createProject = 'create-project';
  static const editProject = 'edit-project';
  static const feedback = 'feedback';
  static const network = 'network';
  static const status = 'status';
  static const more = 'more';
  static const solutionFunction = 'solution-function';
  static const solutionFunctionSettings = 'solution-function-settings';
  static const networkProfile = 'network-profile';
  static const receivedFeedbackDetails = 'received-feedback-details';
  static const requestFeedback = 'request-feedback';
  static const provideFeedback = 'provide-feedback';
  static const statusReport = 'status-report';
  static const groups = 'groups';
  static const monitorGroup = 'monitor-group';
  static const profile = 'profile';
  static const transactionHistory = 'transaction-history';
  static const transactionHistoryDetails = 'transaction-history-details';
  static const feedbackReceipt = 'feedback-receipt';
  static const editProfile = 'edit-profile';
  static const parentAndChildren = 'parent-children';
  static const addChild = 'add-child';
  static const addParent = 'add-parent';
  static const previewSet = 'preview-set';
}

final authProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: Routes.splash,
          path: Routes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: Routes.onboarding,
          path: Routes.onboarding.p,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          name: Routes.signIn,
          path: Routes.signIn.p,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          name: Routes.signUp,
          path: Routes.signUp.p,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: Routes.completeProfile,
          path: Routes.completeProfile.p,
          builder: (context, state) {
            final userId = state.extra as String;
            return CompleteProfileScreen(userId: userId);
          },
        ),
        GoRoute(
          name: Routes.forgotPassword,
          path: Routes.forgotPassword.p,
          builder: (context, state) => ForgotPassScreen(),
        ),
        // GoRoute(
        //   path: '/home-screen',
        //   builder: (context, state) => MyHomePage(),
        // ),
        GoRoute(
          name: Routes.createProject,
          path: Routes.createProject.p,
          builder: (context, state) => const CreateProjectScreen(),
        ),
        GoRoute(
          name: Routes.editProject,
          path: Routes.editProject.p,
          builder: (context, state) => const ProjectEditScreen(),
        ),
        GoRoute(
          name: Routes.solutionFunction,
          path: '${Routes.solutionFunction.p}/:projectId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            return SolutionFunction(projectId: projectId);
          },
        ),
        GoRoute(
          name: Routes.solutionFunctionSettings,
          path: '${Routes.solutionFunctionSettings.p}/:projectId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            return SettingsScreen(projectId: projectId);
          },
        ),

        GoRoute(
          name: Routes.networkProfile,
          path: Routes.networkProfile.p,
          builder: (context, state) {
            return NetworkProfileScreen(
              user: state.extra as UserModel,
            );
          },
        ),
        GoRoute(
          name: Routes.receivedFeedbackDetails,
          path: Routes.receivedFeedbackDetails.p,
          builder: (context, state) => const ReceivedFeedbackDetails(),
        ),
        GoRoute(
          name: Routes.requestFeedback,
          path: Routes.requestFeedback.p,
          builder: (context, state) => RequestFeedbackScreen(
            project: state.extra as ProjectModel,
          ),
        ),
        GoRoute(
          name: Routes.statusReport,
          path: Routes.statusReport.p,
          builder: (context, state) => const StatusReportScreen(),
        ),
        GoRoute(
          name: Routes.groups,
          path: Routes.groups.p,
          builder: (context, state) => const GroupsScreen(),
        ),
        GoRoute(
          name: Routes.monitorGroup,
          path: Routes.monitorGroup.p,
          builder: (context, state) => const MonitorGroupScreen(),
        ),
        GoRoute(
          name: Routes.profile,
          path: Routes.profile.p,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: Routes.transactionHistory,
          path: Routes.transactionHistory.p,
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          name: Routes.transactionHistoryDetails,
          path: Routes.transactionHistoryDetails.p,
          builder: (context, state) => const TransactionHistoryDetailsScreen(),
        ),
        GoRoute(
          name: Routes.feedbackReceipt,
          path: Routes.feedbackReceipt.p,
          builder: (context, state) => const FeedbackReceiptScreen(),
        ),
        GoRoute(
          name: Routes.editProfile,
          path: Routes.editProfile.p,
          builder: (context, state) => EditProfileScreen(
            currentUser: state.extra as UserModel,
          ),
        ),
        GoRoute(
          name: Routes.parentAndChildren,
          path: Routes.parentAndChildren.p,
          builder: (context, state) => ParentAndChildrenScreen(
            userId: state.extra as String,
          ),
        ),
        GoRoute(
          name: Routes.addChild,
          path: Routes.addChild.p,
          builder: (context, state) => AddChildScreen(
            parentId: state.extra as String,
          ),
        ),
        GoRoute(
          name: Routes.addParent,
          path: Routes.addParent.p,
          builder: (context, state) => AddParentScreen(
            currentUserId: state.extra as String,
          ),
        ),
        GoRoute(
          name: Routes.provideFeedback,
          path: Routes.provideFeedback.p,
          builder: (context, state) => ProvideFeedbackScreen(
            feedbackModel: state.extra as FeedbackModel,
          ),
        ),
        GoRoute(
          name: Routes.previewSet,
          path: Routes.previewSet.p,
          builder: (context, state) => PreviewSetScreen(
            feedback: state.extra as FeedbackModel,
          ),
        ),

        // NavBar Routes
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(
              navigationShell: navigationShell,
              context: context,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: Routes.projects,
                  path: Routes.projects.p,
                  builder: (context, state) {
                    return const ProjectsScreen();
                  },
                  routes: const [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: Routes.feedback,
                  path: Routes.feedback.p,
                  builder: (context, state) => const FeedbackScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: Routes.network,
                  path: Routes.network.p,
                  builder: (context, state) => const NetworkScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: Routes.status,
                  path: Routes.status.p,
                  builder: (context, state) => const StatusTabScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: Routes.more,
                  path: Routes.more.p,
                  builder: (context, state) => const MoreDrawer(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final loggedIn = ref.watch(authProvider);

        final loggingIn = state.uri.toString() == Routes.onboarding.p;

        // If not logged in and trying to access a restricted route, redirect to /login
        if (!loggedIn && loggingIn) {
          return Routes.onboarding.p;
        }

        // If logged in and trying to access login page, redirect to /home
        if (loggedIn && loggingIn) {
          return Routes.projects.p;
        }
        return null;
      },
    );
  },
);
