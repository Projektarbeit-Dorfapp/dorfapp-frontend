//Meike Nedwidek
class MenuButtons {

  static const String EDIT = 'Bearbeiten';
  static const String DELETE = 'Löschen';
  static const String LOGOUT = 'Abmelden';
  static const String CLOSE_THREAD = 'Thema schließen';
  static const String SUBSCRIBE = "Pinnen";
  static const String CANCEL_SUBSCRIPTION = "Nicht mehr pinnen";
  static const String DELETE_ALERTS = "Benachrichtigungen löschen";
  //edit and delete
  static const List<String> EditDeleteLogout = <String>[
    EDIT,
    DELETE,
    LOGOUT
  ];

  static const List<String> EditDelete = <String>[
    EDIT,
    DELETE
  ];

  //logout (calendar...?)
  static const List<String> HomePopUpMenu = <String> [
    LOGOUT
  ];

  //boardMessagePage
  static const List<String> BoardMessagePageCreatorAndAdmin = <String> [
    CLOSE_THREAD,
    SUBSCRIBE,
  ];

  //boardMessagePage
  static const List<String> BoardMessagePageNotCreator = <String> [
    SUBSCRIBE,
  ];

  static const List<String> BoardMessagePageCreatorAndAdminCancelSub = <String> [
    CLOSE_THREAD,
    CANCEL_SUBSCRIPTION,
  ];

  static const List<String> BoardMessagePageNotCreatorCancelSub = <String> [
    CANCEL_SUBSCRIPTION,
  ];

  static const List<String> AlertPagePopUpMenu = <String> [
    DELETE_ALERTS,
  ];
}