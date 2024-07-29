
export 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
export 'package:flutter_event_calendar/src/models/calendar_options.dart';
export 'package:flutter_event_calendar/src/models/datetime.dart';
export 'package:flutter_event_calendar/src/models/event.dart';
export 'package:flutter_event_calendar/src/models/style/day_options.dart';
export 'package:flutter_event_calendar/src/models/style/event_options.dart';
export 'package:flutter_event_calendar/src/models/style/headers_options.dart';
export 'package:flutter_event_calendar/src/utils/calendar_types.dart';

import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/providers/calendars/calendar_provider.dart';
import 'package:flutter_event_calendar/src/providers/instance_provider.dart';
import 'package:flutter_event_calendar/src/widgets/calendar_daily.dart';
import 'package:flutter_event_calendar/src/widgets/calendar_monthly.dart';
import 'package:flutter_event_calendar/src/widgets/events.dart';
import 'package:flutter_event_calendar/src/widgets/header.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';




// typedef CalendarChangeCallback = Function(CalendarDateTime);

class CustomEventCalendar extends StatefulWidget {
  static late CalendarProvider calendarProvider;
  static late CalendarDateTime? dateTime;
  static late List<Event> events;
  static List<Event> selectedEvents = [];

  // static late HeaderMonthStringTypes headerMonthStringType;
  // static late HeaderWeekDayStringTypes headerWeekDayStringType;
  static late String calendarLanguage;
  static late CalendarType calendarType;

  CalendarChangeCallback? onChangeDateTime;
  CalendarChangeCallback? onMonthChanged;
  CalendarChangeCallback? onYearChanged;
  CalendarChangeCallback? onDateTimeReset;
  ViewTypeChangeCallback? onChangeViewType;
  VoidCallback? onInit;

  List<CalendarDateTime> specialDays;

  CalendarOptions? calendarOptions;

  DayOptions? dayOptions;

  EventOptions? eventOptions;

  bool showLoadingForEvent;

  HeaderOptions? headerOptions;

  Widget? Function(CalendarDateTime)? middleWidget;

  bool showEvents;

  CustomEventCalendar({
    GlobalKey? key,
    List<Event>? events,
    CalendarDateTime? dateTime,
    this.middleWidget,
    this.calendarOptions,
    this.dayOptions,
    this.eventOptions,
    this.headerOptions,
    this.showLoadingForEvent = false,
    this.specialDays = const [],
    this.onChangeDateTime,
    this.onMonthChanged,
    this.onDateTimeReset,
    this.onInit,
    this.onYearChanged,
    this.onChangeViewType,
    required calendarType,
    calendarLanguage,
    this.showEvents = true
  }) : super(key: key) {
    calendarOptions ??= CalendarOptions();
    headerOptions ??= HeaderOptions();
    eventOptions ??= EventOptions();
    dayOptions ??= DayOptions();

    CustomEventCalendar.calendarType = calendarType ?? CalendarType.GREGORIAN;

    CustomEventCalendar.calendarProvider = createInstance(calendarType);

    if (key?.currentContext == null || calendarType != CustomEventCalendar.calendarType) {
      CustomEventCalendar.dateTime = dateTime ?? calendarProvider.getDateTime();
    }
    CustomEventCalendar.calendarType = calendarType ?? CalendarType.GREGORIAN;
    CustomEventCalendar.calendarLanguage = calendarLanguage ?? 'en';
    CustomEventCalendar.events = events ?? [];
  }

  static void init({
    required CalendarType calendarType,
    CalendarDateTime? dateTime,
    String? calendarLanguage,
  }) {
    CustomEventCalendar.calendarProvider = createInstance(calendarType);
    CustomEventCalendar.dateTime =
        dateTime ?? CustomEventCalendar.calendarProvider.getDateTime();
    CustomEventCalendar.calendarType = calendarType;
    CustomEventCalendar.calendarLanguage = calendarLanguage ?? 'en';
  }

  @override
  _CustomEventCalendarState createState() => _CustomEventCalendarState();
}

class _CustomEventCalendarState extends State<CustomEventCalendar> {
  @override
  void initState() {
    widget.onInit?.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildScopeModels(
      child: (context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(

             mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  color: CalendarOptions.of(context).headerMonthBackColor,
                  shadowColor: CalendarOptions.of(context).headerMonthShadowColor,
                  shape: CalendarOptions.of(context).headerMonthShape,
                  elevation: CalendarOptions.of(context).headerMonthElevation,
                  child: Column(
                    children: [
                      Header(
                        onDateTimeReset: () {
                          widget.onDateTimeReset?.call(CustomEventCalendar.dateTime!);
                          setState(() {});
                        },
                        onMonthChanged: (int selectedMonth) {
                          widget.onMonthChanged?.call(CustomEventCalendar.dateTime!);
                          CalendarUtils.goToMonth(selectedMonth);
                          setState(() {});
                        },
                        onViewTypeChanged: (ViewType viewType) {
                          setState(() {});
                          widget.onChangeViewType?.call(viewType);
                        },
                        onYearChanged: (int selectedYear) {
                          widget.onYearChanged?.call(CustomEventCalendar.dateTime!);
                          CalendarUtils.goToYear(selectedYear);
                          setState(() {});
                        },
                      ),
                      isMonthlyView()
                          ? SingleChildScrollView(
                            child: CalendarMonthly(
                                specialDays: widget.specialDays,
                                onCalendarChanged: () {
                                  widget.onChangeDateTime
                                      ?.call(CustomEventCalendar.dateTime!);

                                  setState(() {});
                                }),
                          )
                          : CalendarDaily(
                              specialDays: widget.specialDays,
                              onCalendarChanged: () {
                                widget.onChangeDateTime
                                    ?.call(CustomEventCalendar.dateTime!);
                                setState(() {});
                              }),
                    ],
                  ),
                ),
                if (widget.middleWidget != null)
                  widget.middleWidget!.call(CustomEventCalendar.dateTime!)!,
                Events(onEventsChanged: () {
                  widget.onChangeDateTime?.call(CustomEventCalendar.dateTime!);
                  setState(() {});
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  isMonthlyView() {
    return widget.calendarOptions?.viewType == ViewType.MONTHLY;
  }

  buildScopeModels({required WidgetBuilder child}) {
    return ScopedModel<CalendarOptions>(
      model: widget.calendarOptions!,
      child: ScopedModel<DayOptions>(
        model: widget.dayOptions!,
        child: ScopedModel<EventOptions>(
          model: widget.eventOptions!,
          child: ScopedModel<HeaderOptions>(
            model: widget.headerOptions!,
            child: Builder(builder: child),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// reset date time after disposing child
    CustomEventCalendar.dateTime = CustomEventCalendar.calendarProvider.getDateTime();
    // CustomEventCalendar.dateTime = null;
    super.dispose();
  }
}
