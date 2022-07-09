// To parse this JSON data, do
//
//     final cancelListPrinterModel = cancelListPrinterModelFromJson(jsonString);

import 'dart:convert';

class CancelListPrinterModel {
  CancelListPrinterModel(
      {this.name,
      this.name2,
      this.branch,
      this.offline,
      this.outOfPaper,
      this.busy,
      this.inError,
      this.warehouse,
      this.isPaperJammed,
      this.isNotAvailable,
      this.isDoorOpened,
      this.isPaused,
      this.jobs,
      this.needUserIntervention,
      this.allProblem,
      this.onlyUserGroup,
      this.icon});

  String? name;
  String? name2;
  String? branch;
  bool? offline;
  bool? outOfPaper;
  bool? busy;
  bool? inError;
  String? warehouse;
  bool? isPaperJammed;
  bool? isNotAvailable;
  bool? isDoorOpened;
  bool? isPaused;
  List<Job>? jobs;
  bool? needUserIntervention;
  List<String>? allProblem;
  List<String>? onlyUserGroup;
  String? icon;

  factory CancelListPrinterModel.fromRawJson(String str) =>
      CancelListPrinterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelListPrinterModel.fromJson(Map<String, dynamic> json) =>
      CancelListPrinterModel(
        name: json["name"] == null ? null : json["name"],
        name2: json["name2"] == null ? null : json["name2"],
        branch: json["branch"] == null ? null : json["branch"],
        offline: json["offline"] == null ? null : json["offline"],
        outOfPaper: json["outOfPaper"] == null ? null : json["outOfPaper"],
        busy: json["busy"] == null ? null : json["busy"],
        inError: json["inError"] == null ? null : json["inError"],
        warehouse: json["warehouse"] == null ? null : json["warehouse"],
        isPaperJammed:
            json["isPaperJammed"] == null ? null : json["isPaperJammed"],
        isNotAvailable:
            json["isNotAvailable"] == null ? null : json["isNotAvailable"],
        isDoorOpened:
            json["isDoorOpened"] == null ? null : json["isDoorOpened"],
        isPaused: json["isPaused"] == null ? null : json["isPaused"],
        jobs: json["jobs"] == null
            ? null
            : List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
        needUserIntervention: json["needUserIntervention"] == null
            ? null
            : json["needUserIntervention"],
        allProblem: json["allProblem"] == null
            ? null
            : List<String>.from(json["allProblem"].map((x) => x)),
        onlyUserGroup: json["onlyUserGroup"] == null
            ? null
            : List<String>.from(json["onlyUserGroup"].map((x) => x)),
        icon: json["icon"] == null ? null : json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "name2": name2 == null ? null : name2,
        "branch": branch == null ? null : branch,
        "offline": offline == null ? null : offline,
        "outOfPaper": outOfPaper == null ? null : outOfPaper,
        "busy": busy == null ? null : busy,
        "inError": inError == null ? null : inError,
        "warehouse": warehouse == null ? null : warehouse,
        "isPaperJammed": isPaperJammed == null ? null : isPaperJammed,
        "isNotAvailable": isNotAvailable == null ? null : isNotAvailable,
        "isDoorOpened": isDoorOpened == null ? null : isDoorOpened,
        "isPaused": isPaused == null ? null : isPaused,
        "jobs": jobs == null
            ? null
            : List<dynamic>.from(jobs!.map((x) => x.toJson())),
        "needUserIntervention":
            needUserIntervention == null ? null : needUserIntervention,
        "allProblem": allProblem == null
            ? null
            : List<dynamic>.from(allProblem!.map((x) => x)),
        "icon": icon == null ? null : icon,
      };
}

class Job {
  Job({
    this.id,
    this.status,
    this.name,
    this.date,
    this.currentDate,
    this.pages,
    this.status2,
    this.userPrint,
    this.index,
  });

  int? id;
  String? status;
  String? name;
  String? date;
  String? currentDate;
  int? pages;
  String? status2;
  String? userPrint;
  int? index;

  factory Job.fromRawJson(String str) => Job.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"] == null ? null : json["id"],
        status: json["status"] == null ? null : json["status"],
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : json["date"],
        currentDate: json["currentDate"] == null ? null : json["currentDate"],
        pages: json["pages"] == null ? null : json["pages"],
        status2: json["status2"] == null ? null : json["status2"],
        userPrint: json["userPrint"] == null ? null : json["userPrint"],
        index: json["index"] == null ? null : json["index"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "status": status == null ? null : status,
        "name": name == null ? null : name,
        "date": date == null ? null : date,
        "currentDate": currentDate == null ? null : currentDate,
        "pages": pages == null ? null : pages,
        "status2": status2 == null ? null : status2,
        "userPrint": userPrint == null ? null : userPrint,
        "index": index == null ? null : index,
      };
}
