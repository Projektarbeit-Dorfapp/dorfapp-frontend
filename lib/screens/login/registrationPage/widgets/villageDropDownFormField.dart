import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class VillageDropDownFormField extends StatefulWidget {
  @override
  _VillageDropDownFormFieldState createState() => _VillageDropDownFormFieldState();
}

class _VillageDropDownFormFieldState extends State<VillageDropDownFormField> {
  ListItem _selectedItem;

  List<DropdownMenuItem> _dropDownList;
  List<ListItem> _dropdownItems = [
    ListItem(0, "Wähle dein Dorf aus"),
    ListItem(1, "Bornstedt"),
    ListItem(2, "Gröde"),
  ];
  @override
  void initState() {
    _dropDownList = _buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropDownList[0].value;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      child: DropdownButtonFormField(
        decoration: LoginInputDecoration(icon: Icons.home, color: Theme.of(context).buttonColor).decorate(context),
        value: _selectedItem,
        items: _dropDownList,
        onChanged: (selection){
          setState(() {
            Provider.of<RegistrationValidator>(context, listen: false).setVillage(selection);
            _selectedItem = selection;
          });
        },
        validator: (selection){
          if(selection == _dropdownItems[0]){
            return "Wähle ein Dorf";
          } else return null;
        },
      ),
    );
  }
  List<DropdownMenuItem<ListItem>> _buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }
}
class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}