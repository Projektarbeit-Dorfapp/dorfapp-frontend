class Address{

  final String street;
  final String houseNumber;
  final String zipCode;
  final String district;

  Address({this.street, this.houseNumber, this.zipCode, this.district});

  String getAddressFormat() {
    if(this.zipCode == '' && this.district == '' && this.street != '') {
      return '${this.street} ${this.houseNumber}';
    }

    if(this.street == '' && this.houseNumber == '' && this.zipCode != '') {
      return '${this.zipCode} ${this.district}';
    }

    return '${this.street} ${this.houseNumber}, ${this.zipCode} ${this.district}';
  }

}