// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoccerMatchAdapter extends TypeAdapter<SoccerMatch> {
  @override
  final int typeId = 2;

  @override
  SoccerMatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoccerMatch(
      id: fields[0] as int,
      date: fields[1] as String,
      time: fields[2] as String,
      competitionId: fields[3] as int,
      competitionName: fields[4] as String,
      competitionLogo: fields[5] as String,
      homeTeam: fields[6] as Team,
      awayTeam: fields[7] as Team,
      status: fields[8] as MatchStatus,
      stadium: fields[9] as String?,
      referee: fields[10] as String?,
      elapsed: fields[11] as int?,
      homeGoals: fields[12] as int?,
      awayGoals: fields[13] as int?,
      homeHalfTimeGoals: fields[14] as int?,
      awayHalfTimeGoals: fields[15] as int?,
      isSubscribed: fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SoccerMatch obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.competitionId)
      ..writeByte(4)
      ..write(obj.competitionName)
      ..writeByte(5)
      ..write(obj.competitionLogo)
      ..writeByte(6)
      ..write(obj.homeTeam)
      ..writeByte(7)
      ..write(obj.awayTeam)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.stadium)
      ..writeByte(10)
      ..write(obj.referee)
      ..writeByte(11)
      ..write(obj.elapsed)
      ..writeByte(12)
      ..write(obj.homeGoals)
      ..writeByte(13)
      ..write(obj.awayGoals)
      ..writeByte(14)
      ..write(obj.homeHalfTimeGoals)
      ..writeByte(15)
      ..write(obj.awayHalfTimeGoals)
      ..writeByte(16)
      ..write(obj.isSubscribed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoccerMatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MatchStatusAdapter extends TypeAdapter<MatchStatus> {
  @override
  final int typeId = 3;

  @override
  MatchStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MatchStatus.toBeDefined;
      case 1:
        return MatchStatus.notStarted;
      case 2:
        return MatchStatus.firstHalf;
      case 3:
        return MatchStatus.halfTime;
      case 4:
        return MatchStatus.secondHalf;
      case 5:
        return MatchStatus.extraTime;
      case 6:
        return MatchStatus.penalty;
      case 7:
        return MatchStatus.fullTime;
      case 8:
        return MatchStatus.afterExtraTime;
      case 9:
        return MatchStatus.breakTime;
      case 10:
        return MatchStatus.suspended;
      case 11:
        return MatchStatus.interrupted;
      case 12:
        return MatchStatus.postponed;
      case 13:
        return MatchStatus.cancelled;
      case 14:
        return MatchStatus.abandoned;
      case 15:
        return MatchStatus.awarded;
      case 16:
        return MatchStatus.walkover;
      case 17:
        return MatchStatus.unknown;
      default:
        return MatchStatus.toBeDefined;
    }
  }

  @override
  void write(BinaryWriter writer, MatchStatus obj) {
    switch (obj) {
      case MatchStatus.toBeDefined:
        writer.writeByte(0);
        break;
      case MatchStatus.notStarted:
        writer.writeByte(1);
        break;
      case MatchStatus.firstHalf:
        writer.writeByte(2);
        break;
      case MatchStatus.halfTime:
        writer.writeByte(3);
        break;
      case MatchStatus.secondHalf:
        writer.writeByte(4);
        break;
      case MatchStatus.extraTime:
        writer.writeByte(5);
        break;
      case MatchStatus.penalty:
        writer.writeByte(6);
        break;
      case MatchStatus.fullTime:
        writer.writeByte(7);
        break;
      case MatchStatus.afterExtraTime:
        writer.writeByte(8);
        break;
      case MatchStatus.breakTime:
        writer.writeByte(9);
        break;
      case MatchStatus.suspended:
        writer.writeByte(10);
        break;
      case MatchStatus.interrupted:
        writer.writeByte(11);
        break;
      case MatchStatus.postponed:
        writer.writeByte(12);
        break;
      case MatchStatus.cancelled:
        writer.writeByte(13);
        break;
      case MatchStatus.abandoned:
        writer.writeByte(14);
        break;
      case MatchStatus.awarded:
        writer.writeByte(15);
        break;
      case MatchStatus.walkover:
        writer.writeByte(16);
        break;
      case MatchStatus.unknown:
        writer.writeByte(17);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
