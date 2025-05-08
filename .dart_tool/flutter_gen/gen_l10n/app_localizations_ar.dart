import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سوكر بلس';

  @override
  String get todayMatches => 'مباريات اليوم';

  @override
  String get competitions => 'المسابقات';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get standings => 'الترتيب';

  @override
  String get matches => 'المباريات';

  @override
  String get teams => 'الفرق';

  @override
  String get searchCompetitions => 'البحث عن مسابقات';

  @override
  String get noCompetitionsFound => 'لم يتم العثور على مسابقات';

  @override
  String get favorites => 'المفضلة فقط';

  @override
  String get upcomingMatches => 'المباريات القادمة';

  @override
  String get noMatchesFound => 'لم يتم العثور على مباريات';

  @override
  String get matchDetails => 'تفاصيل المباراة';

  @override
  String get summary => 'ملخص';

  @override
  String get lineups => 'التشكيلة';

  @override
  String get formation => 'التكوين';

  @override
  String get timeline => 'الجدول الزمني';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get possession => 'الاستحواذ';

  @override
  String get shots => 'التسديدات';

  @override
  String get shotsOnTarget => 'التسديدات على المرمى';

  @override
  String get corners => 'الركنيات';

  @override
  String get offsides => 'التسلل';

  @override
  String get fouls => 'الأخطاء';

  @override
  String get startingXI => 'التشكيلة الأساسية';

  @override
  String get substitutes => 'البدلاء';

  @override
  String get completed => 'مكتملة';

  @override
  String get live => 'مباشرة';

  @override
  String get upcoming => 'قادمة';

  @override
  String get fullTime => 'وقت كامل';

  @override
  String get referee => 'الحكم';

  @override
  String get noStandingsAvailable => 'لا يوجد ترتيب متاح';

  @override
  String get noTeamsAvailable => 'لا توجد فرق متاحة';

  @override
  String get subscribe => 'اشتراك';

  @override
  String get subscribed => 'مشترك';

  @override
  String subscriptionSuccess(Object team) {
    return 'أنت الآن مشترك في مباريات $team';
  }

  @override
  String unsubscriptionSuccess(Object team) {
    return 'لقد ألغيت اشتراكك من مباريات $team';
  }

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get rank => 'الترتيب';

  @override
  String get team => 'الفريق';

  @override
  String get played => 'لعب';

  @override
  String get won => 'فوز';

  @override
  String get drawn => 'تعادل';

  @override
  String get lost => 'خسارة';

  @override
  String get goalDifference => 'فرق الأهداف';

  @override
  String get points => 'النقاط';

  @override
  String get vs => 'ضد';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get language => 'اللغة';
}
