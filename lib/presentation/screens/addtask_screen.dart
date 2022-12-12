import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/data/models/resident_model.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/repositories/firestore_crud.dart';
import 'package:todo_app/presentation/widgets/mybutton.dart';
import 'package:todo_app/presentation/widgets/myindicator.dart';
import 'package:todo_app/presentation/widgets/mytextfield.dart';
import 'package:todo_app/shared/constants/consts_variables.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/shared/utilities.dart';

import '../../shared/services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({
    this.task,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  get isEditMote => widget.task != null;

  late TextEditingController _titlecontroller;
  late TextEditingController _shiftcontroller;
  late TextEditingController _notecontroller;
  late DateTime currentdate;
  static var _starthour = TimeOfDay.now();

  var endhour = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  late int _selectedReminder;
  late int _selectedcolor;

  List<DropdownMenuItem<int>> menuItems = const [
    DropdownMenuItem(
        child: Text(
          "5 Min Earlier",
        ),
        value: 5),
    DropdownMenuItem(
        child: Text(
          "10 Min Earlier",
        ),
        value: 10),
    DropdownMenuItem(
        child: Text(
          "15 Min Earlier",
        ),
        value: 15),
    DropdownMenuItem(
        child: Text(
          "20 Min Earlier",
        ),
        value: 20),
  ];

  @override
  void initState() {
    super.initState();
    _titlecontroller =
        TextEditingController(text: isEditMote ? widget.task!.title : '');
    _shiftcontroller =
        TextEditingController(text: isEditMote ? widget.task!.shift : '');
    _notecontroller =
        TextEditingController(text: isEditMote ? widget.task!.note : '');

    currentdate =
        isEditMote ? DateTime.parse(widget.task!.date) : DateTime.now();
    endhour = TimeOfDay(
      hour: _starthour.hour + 1,
      minute: _starthour.minute,
    );
    _selectedReminder = isEditMote ? widget.task!.reminder : 5;
    _selectedcolor = isEditMote ? widget.task!.colorindex : 0;
  }

  @override
  void dispose() {
    super.dispose();
    _titlecontroller.dispose();
    _notecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildform(context),
          ),
        ),
      ),
    );
  }

  Form _buildform(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1.h,
          ),
          _buildAppBar(context),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Select Resident',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            readonly: true,
            hint: 'Select Resident',
            icon: Icons.arrow_drop_down,
            showicon: false,
            validator: (value) {
              return value!.isEmpty ? "Tap to select a Resident" : null;
            },
            ontap: () {
              _showBottomSheet(context);
            },
            textEditingController: _titlecontroller,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Select a Shift',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            readonly: true,
            hint: 'Select a Shift',
            icon: Icons.arrow_drop_down,
            showicon: false,
            validator: (value) {
              return value!.isEmpty ? "Tap to select a Resident" : null;
            },
            ontap: () {
              _showBottomSheetForShift(context);
            },
            textEditingController: _shiftcontroller,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Task',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: 'Enter Task Here',
            icon: Icons.ac_unit,
            showicon: false,
            // maxlenght: 110,
            validator: (value) {
              return value!.isEmpty ? "Please Enter A Note" : null;
            },
            textEditingController: _notecontroller,
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            'Date',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy').format(currentdate),
            icon: Icons.calendar_today,
            readonly: true,
            showicon: false,
            validator: (value) {},
            ontap: () {
              _showdatepicker();
            },
            textEditingController: TextEditingController(),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Time',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    MyTextfield(
                      hint: DateFormat('HH:mm a').format(DateTime(
                          0, 0, 0, _starthour.hour, _starthour.minute)),
                      icon: Icons.watch_outlined,
                      showicon: false,
                      readonly: true,
                      validator: (value) {},
                      ontap: () {
                        Navigator.push(
                            context,
                            showPicker(
                              value: _starthour,
                              is24HrFormat: true,
                              accentColor: Appcolors.green,
                              onChange: (TimeOfDay newvalue) {
                                setState(() {
                                  _starthour = newvalue;
                                  endhour = TimeOfDay(
                                    hour: _starthour.hour < 22
                                        ? _starthour.hour + 1
                                        : _starthour.hour,
                                    minute: _starthour.minute,
                                  );
                                });
                              },
                            ));
                      },
                      textEditingController: TextEditingController(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Time',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    MyTextfield(
                      hint: DateFormat('HH:mm a').format(
                          DateTime(0, 0, 0, endhour.hour, endhour.minute)),
                      icon: Icons.watch,
                      showicon: false,
                      readonly: true,
                      validator: (value) {},
                      ontap: () {
                        Navigator.push(
                            context,
                            showPicker(
                              value: endhour,
                              is24HrFormat: true,
                              minHour: _starthour.hour.toDouble() - 1,
                              accentColor: Appcolors.green,
                              onChange: (TimeOfDay newvalue) {
                                setState(() {
                                  endhour = newvalue;
                                });
                              },
                            ));
                      },
                      textEditingController: TextEditingController(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Reminder',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          _buildDropdownButton(context),
          SizedBox(
            height: 3.h,
          ),
          MyButton(
            color: Appcolors.kBlackColor800,
            width: 80.w,
            title: isEditMote ? "Update Task" : 'Create Task',
            func: () {
              _addtask();
            },
          )
        ],
      ),
    );
  }

  _addtask() {
    if (_formKey.currentState!.validate()) {
      TaskModel task = TaskModel(
          title: _titlecontroller.text,
          shift: _shiftcontroller.text,
          note: _notecontroller.text,
          date: DateFormat('yyyy-MM-dd').format(currentdate),
          starttime: _starthour.format(context),
          endtime: endhour.format(context),
          reminder: _selectedReminder,
          colorindex: _selectedcolor,
          id: '',
          status: 'Open');
      isEditMote
          ? FireStoreCrud().updateTask(
              docid: widget.task!.id,
              title: _titlecontroller.text,
              shift: _shiftcontroller.text,
              note: _notecontroller.text,
              date: DateFormat('yyyy-MM-dd').format(currentdate),
              starttime: _starthour,
              endtime: endhour.format(context),
              reminder: _selectedReminder,
              colorindex: _selectedcolor,
            )
          : FireStoreCrud().addTask(task: task);

      NotificationsHandler.createScheduledNotification(
        date: currentdate.day,
        hour: _starthour.hour,
        minute: _starthour.minute - _selectedReminder,
        title: '${Emojis.time_watch} It Is Time For Your Task!!!',
        body: _titlecontroller.text,
      );

      NotificationsHandler.createScheduledNotification(
        date: currentdate.day,
        hour: endhour.hour,
        minute: endhour.minute - _selectedReminder,
        title: '${Emojis.time_watch} Your task ends now!!!',
        body: _titlecontroller.text,
      );

      Navigator.pop(context);
    }
  }

  DropdownButtonFormField<int> _buildDropdownButton(BuildContext context) {
    return DropdownButtonFormField(
      value: _selectedReminder,
      items: menuItems,
      style: Theme.of(context)
          .textTheme
          .headline1!
          .copyWith(fontSize: 9.sp, color: Appcolors.kGreyColor900),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Appcolors.kGreyColor900,
        size: 25.sp,
      ),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Appcolors.kGreyColor900),
          borderRadius: BorderRadius.circular(size),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Appcolors.kWhiteColor),
          borderRadius: BorderRadius.circular(size),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      ),
      onChanged: (int? val) {
        setState(() {
          _selectedReminder = val!;
        });
      },
    );
  }

  _showdatepicker() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? currentdate = selecteddate : null;
    });
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            size: 30.sp,
          ),
        ),
        Text(
          isEditMote ? 'Update Task' : 'Add Task',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox()
      ],
    );
  }

  Future<dynamic> _showBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 1),
          topRight: Radius.circular(size * 1),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 2.4,
                maxHeight: MediaQuery.of(context).size.height / 2.4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: size * 1),
              child: Scaffold(
                backgroundColor: Appcolors.kGreyColor100,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: size * 2),
                      getTaskDetailTItle(context, 'Resident'),
                      const SizedBox(height: size + 4),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: StreamBuilder(
                            stream: FireStoreCrud().getResident(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ResidentModel>> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('No Residents found'));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const MyCircularIndicator();
                              }

                              return snapshot.data!.isNotEmpty
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        var task = snapshot.data![index];

                                        return ListTile(
                                            onTap: () {
                                              setState(() {
                                                _titlecontroller.text =
                                                    task.name;
                                              });
                                              Navigator.pop(context);
                                            },
                                            title: Text(
                                              task.name,
                                            ));
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                    )
                                  : Center(child: Text('No Residents found'));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: size * 2),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> _showBottomSheetForShift(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 1),
          topRight: Radius.circular(size * 1),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 2.4,
                maxHeight: MediaQuery.of(context).size.height / 2.4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: size * 1),
              child: Scaffold(
                backgroundColor: Appcolors.kGreyColor100,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: size * 2),
                      getTaskDetailTItle(context, 'Shift'),
                      const SizedBox(height: size + 4),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                String text = (index == 0)
                                    ? 'Morning'
                                    : (index == 1)
                                        ? 'Evening'
                                        : 'Night';
                                return ListTile(
                                    onTap: () {
                                      setState(() {
                                        _shiftcontroller.text = text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    title: Text(text));
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            )),
                      ),
                      const SizedBox(height: size * 2),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
