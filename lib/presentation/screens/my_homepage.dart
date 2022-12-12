import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/bloc/auth/authentication_cubit.dart';
import 'package:todo_app/bloc/connectivity/connectivity_cubit.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/repositories/firestore_crud.dart';
import 'package:todo_app/presentation/widgets/mybutton.dart';
import 'package:todo_app/presentation/widgets/myindicator.dart';
import 'package:todo_app/presentation/widgets/mysnackbar.dart';
import 'package:todo_app/presentation/widgets/mytextfield.dart';
import 'package:todo_app/presentation/widgets/task_container.dart';
import 'package:todo_app/shared/constants/assets_path.dart';
import 'package:todo_app/shared/constants/consts_variables.dart';
import 'package:todo_app/shared/constants/strings.dart';
import 'package:todo_app/shared/services/notification_service.dart';
import 'package:todo_app/shared/styles/colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var currentdate = DateTime.now();

  final TextEditingController _usercontroller = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  @override
  void initState() {
    super.initState();

    NotificationsHandler.requestpermission(context);
  }

  @override
  void dispose() {
    super.dispose();

    _usercontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authenticationCubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    final user = FirebaseAuth.instance.currentUser;
    String username = user!.isAnonymous ? 'Anonymous' : 'User';

    return Scaffold(
        backgroundColor: Appcolors.kGreyColor100,
        body: MultiBlocListener(
            listeners: [
              BlocListener<ConnectivityCubit, ConnectivityState>(
                  listener: (context, state) {
                if (state is ConnectivityOnlineState) {
                  MySnackBar.error(
                      message: 'You Are Online Now ',
                      color: Colors.green,
                      context: context);
                } else {
                  MySnackBar.error(
                      message: 'Please Check Your Internet Connection',
                      color: Colors.red,
                      context: context);
                }
              }),
              BlocListener<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is UnAuthenticationState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, welcomepage, (route) => false);
                  }
                },
              )
            ],
            child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationLoadingState) {
                  return const MyCircularIndicator();
                }

                return SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // NotificationsHandler.createNotification();
                            },
                            child: SizedBox(
                              height: 8.h,
                              child: CircleAvatar(
                                backgroundColor: Appcolors.kGreyColor400,
                                child: Image.asset(
                                  profileimages[profileimagesindex],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: Text(
                              user.displayName != null
                                  ? 'Hello ${user.displayName}'
                                  : ' Hello $username',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              authenticationCubit.signout();
                            },
                            child: Icon(
                              Icons.logout_outlined,
                              size: 20.sp,
                              color: Appcolors.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('MMMM, dd').format(currentdate),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 15.sp),
                          ),
                          const Spacer(),
                          MyButton(
                            color: Appcolors.kBlackColor800,
                            width: 30.w,
                            title: '+ Add Task',
                            func: () {
                              Navigator.pushNamed(
                                context,
                                addtaskpage,
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      _buildDatePicker(context, connectivitycubit),
                      SizedBox(
                        height: 4.h,
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FireStoreCrud().getTasks(
                          mydate: DateFormat('yyyy-MM-dd').format(currentdate),
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TaskModel>> snapshot) {
                          if (snapshot.hasError) {
                            return _nodatawidget();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const MyCircularIndicator();
                          }

                          return snapshot.data!.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var task = snapshot.data![index];
                                    Widget _taskcontainer = TaskContainer(
                                      id: task.id,
                                      shift: task.shift,
                                      color: colors[task.colorindex],
                                      title: task.title,
                                      starttime: task.starttime,
                                      endtime: task.endtime,
                                      note: task.note,
                                      status: task.status,
                                    );
                                    return InkWell(
                                        onTap: () {
                                          // Navigator.pushNamed(
                                          //     context, addtaskpage,
                                          //     arguments: task);

                                          _showBottomSheetForUpdate(
                                              context, task);
                                        },
                                        child: index % 2 == 0
                                            ? BounceInLeft(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: _taskcontainer)
                                            : BounceInRight(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: _taskcontainer));
                                  },
                                )
                              : _nodatawidget();
                        },
                      )),
                    ],
                  ),
                ));
              },
            )));
  }

  Future<dynamic> _showBottomSheetForUpdate(
      BuildContext context, TaskModel task) {
    // var user = FirebaseAuth.instance.currentUser!.isAnonymous;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: ((context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      task.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Appcolors.kBlackColor800,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //  margin: EdgeInsets.symmetric(vertical: 1.h),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red),
                          child: Text(
                            task.shift,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Appcolors.kWhiteColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                        SizedBox(
                          width: 1.h,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green.withOpacity(0.2)),
                          child: Text(
                            task.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.green,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FireStoreCrud().updateTask(
                              docid: task.id,
                              title: task.title,
                              shift: (task.shift == 'Morning')
                                  ? 'Evening'
                                  : (task.shift == 'Evening')
                                      ? 'Night'
                                      : 'Morning',
                              note: task.note,
                              date: task.date,
                              starttime: task.starttime,
                              endtime: task.endtime,
                              reminder: task.reminder,
                              colorindex: task.colorindex,
                              status: task.status,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 40.w,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 13),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                            child: Text(
                              'Move to next shift',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                    color: Appcolors.kWhiteColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            FireStoreCrud().updateTask(
                                docid: task.id,
                                title: task.title,
                                shift: task.shift,
                                note: task.note,
                                date: task.date,
                                starttime: task.starttime,
                                endtime: task.endtime,
                                reminder: task.reminder,
                                colorindex: task.colorindex,
                                status: 'Done');
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 40.w,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 13),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.indigo),
                            child: Text(
                              'Complete task',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _nodatawidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            MyAssets.clipboard,
            height: 15.h,
          ),
          SizedBox(height: 3.h),
          Text(
            'No Task Found',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  SizedBox _buildDatePicker(
      BuildContext context, ConnectivityCubit connectivityCubit) {
    return SizedBox(
      height: 15.h,
      child: DatePicker(
        DateTime.now(),
        width: 20.w,
        initialSelectedDate: DateTime.now(),
        dateTextStyle:
            Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18.sp),
        dayTextStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 10.sp, color: Appcolors.black),
        monthTextStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 10.sp, color: Appcolors.black),
        selectionColor: Appcolors.green,
        onDateChange: (DateTime newdate) {
          setState(() {
            currentdate = newdate;
          });
          if (connectivityCubit.state is ConnectivityOnlineState) {
          } else {
            MySnackBar.error(
                message: 'Please Check Your Internet Conection',
                color: Colors.red,
                context: context);
          }
        },
      ),
    );
  }
}
