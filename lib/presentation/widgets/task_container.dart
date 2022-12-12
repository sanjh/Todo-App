import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/data/repositories/firestore_crud.dart';
import 'package:todo_app/presentation/widgets/mybutton.dart';
import 'package:todo_app/shared/styles/colors.dart';

class TaskContainer extends StatelessWidget {
  final String id;
  final Color color;
  final String title;
  final String starttime;
  final String endtime;
  final String note;
  final String shift;
  final String status;

  const TaskContainer(
      {Key? key,
      required this.id,
      required this.color,
      required this.title,
      required this.starttime,
      required this.endtime,
      required this.note,
      required this.shift,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      onDismissed: (direction) {
        FireStoreCrud().deleteTask(docid: id);
      },
      background: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: Container(
        width: 100.w,
        height: 22.h,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              note,
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
            Text(
              '$starttime - $endtime',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Appcolors.kGreyColor800,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  //  margin: EdgeInsets.symmetric(vertical: 1.h),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red),
                  child: Text(
                    shift,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Appcolors.kWhiteColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green.withOpacity(0.2)),
                  child: Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Colors.green,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
