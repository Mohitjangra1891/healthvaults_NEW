// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WeeklyWorkoutPlan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutPlan2Adapter extends TypeAdapter<WorkoutPlan2> {
  @override
  final int typeId = 4;

  @override
  WorkoutPlan2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan2(
      planName: fields[0] as String,
      achievement: fields[1] as String,
      remark1: fields[2] as String,
      remark2: fields[3] as String,
      workouts: (fields[4] as Map).cast<String, WorkoutDay>(),
      reflectionQuestions: (fields[5] as List).cast<String>(),
      startDate: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan2 obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.planName)
      ..writeByte(1)
      ..write(obj.achievement)
      ..writeByte(2)
      ..write(obj.remark1)
      ..writeByte(3)
      ..write(obj.remark2)
      ..writeByte(4)
      ..write(obj.workouts)
      ..writeByte(5)
      ..write(obj.reflectionQuestions)
      ..writeByte(6)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlan2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutDayAdapter extends TypeAdapter<WorkoutDay> {
  @override
  final int typeId = 5;

  @override
  WorkoutDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutDay(
      theme: fields[0] as String,
      routine: (fields[1] as List).cast<RoutineItem>(),
      coachTip: fields[2] as String,
      commonMistake: fields[3] as String,
      alternative: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutDay obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.theme)
      ..writeByte(1)
      ..write(obj.routine)
      ..writeByte(2)
      ..write(obj.coachTip)
      ..writeByte(3)
      ..write(obj.commonMistake)
      ..writeByte(4)
      ..write(obj.alternative);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoutineItemAdapter extends TypeAdapter<RoutineItem> {
  @override
  final int typeId = 6;

  @override
  RoutineItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineItem(
      type: fields[0] as String,
      name: fields[1] as String,
      instruction: fields[2] as String,
      duration: fields[3] as String?,
      reps: fields[4] as String?,
      isCompleted: fields[5] as bool,
      userNote: fields[6] as String?,
      completedIN: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.instruction)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.reps)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.userNote)
      ..writeByte(7)
      ..write(obj.completedIN);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
