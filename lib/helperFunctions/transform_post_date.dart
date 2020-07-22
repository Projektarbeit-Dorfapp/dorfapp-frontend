///Matthias Maxelon
///
///USE relative_date.dart [RelativeDate]-Widget instead
class TransformPostDate{
  static String transform(DateTime date) {
    DateTime entryDate = date;
    DateTime currentDate = DateTime.now();
    int dayDifference = currentDate.difference(entryDate).inDays;
    String transformedText = "";
    if (dayDifference == 0) {
      transformedText = _transformToHours(entryDate, currentDate);
    } else if (dayDifference == 1) {
      transformedText = dayDifference.toString() + " Tag";
    } else if (dayDifference > 28) {
      return _transformToFullDate(entryDate, currentDate);
    } else {
      transformedText = dayDifference.toString() + " Tage";
    }
    return transformedText;
  }

  static String _transformToFullDate(DateTime postingDate, DateTime currentDate) {
    return postingDate.day.toString() +
        "." +
        postingDate.month.toString() +
        "." +
        postingDate.year.toString();
  }

  static String _transformToHours(DateTime postingDate, DateTime currentDate) {
    int hourDifference = currentDate.difference(postingDate).inHours;
    String transformedText = "";
    if (hourDifference == 0) {
      return _transformToMinutes(postingDate, currentDate);
    } else if (hourDifference == 1) {
      transformedText = hourDifference.toString() + " Stunde";
    } else {
      transformedText = hourDifference.toString() + " Stunden";
    }
    return transformedText;
  }

  static String _transformToMinutes(DateTime postingDate, DateTime currentDate) {
    int minuteDifference = currentDate.difference(postingDate).inMinutes;
    String transformedText = "";
    if (minuteDifference == 0) {
      transformedText = "Gerade eben";
    }
    if (minuteDifference == 1) {
      transformedText = minuteDifference.toString() + " Minute";
    } else if (minuteDifference > 1 && minuteDifference < 61) {
      transformedText = minuteDifference.toString() + " Minuten";
    }
    return transformedText;
  }
}