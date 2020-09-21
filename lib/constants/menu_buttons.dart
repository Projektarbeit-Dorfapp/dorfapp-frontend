//Meike Nedwidek
class MenuButtons {

  static const String EDIT = 'Bearbeiten';
  static const String DELETE = 'Löschen';
  static const String LOGOUT = 'Abmelden';
  static const String CLOSE_THREAD = 'Thema schließen';
  static const String SUBSCRIBE = "Pinnen";
  static const String CANCEL_SUBSCRIPTION = "Nicht mehr pinnen";
  static const String DELETE_ALERTS = "Benachrichtigungen löschen";
  static const String SORT_DESCENDING = "Neuste zuerst";
  static const String SORT_ASCENDING = "Älteste zuerst";
  static const String SORT_TOP = "Top Kommentare";

  //edit and delete
  static const List<String> EditDeleteLogout = <String>[
    EDIT,
    DELETE,
    LOGOUT
  ];

  static const List<String> CommentSorting = <String>[
    SORT_DESCENDING,
    SORT_ASCENDING
  ];

  static const List<String> NewsSorting = <String>[
    SORT_DESCENDING,
    SORT_ASCENDING,
    //Einkommentieren, wenn die Likes auf der Top-Ebene der News implementiert werden
    //SORT_TOP
  ];

  static const List<String> EditDelete = <String>[
    EDIT,
    DELETE
  ];

  //logout (calendar...?)
  static const List<String> HomePopUpMenu = <String> [
    LOGOUT
  ];
  static const List<String> AlertPagePopUpMenu = <String> [
    DELETE_ALERTS,
  ];

  static const List<String> SubPopUpMenu = <String> [
    SUBSCRIBE
  ];

  static const List<String> CancelSubPopUpMenu = <String> [
    CANCEL_SUBSCRIPTION,
  ];

}