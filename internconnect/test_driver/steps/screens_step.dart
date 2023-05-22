import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric LoginPage() {

  return given<FlutterWorld> (
    'I am on the login page',
        (context) async {
      final locator = find.byValueKey('loginpage');
      await FlutterDriverUtils.isPresent(context.world.driver, locator);
    },
  );
}

StepDefinitionGeneric MainPage() {

  return given<FlutterWorld> (
    'I am on the main page',
        (context) async {
      final locator = find.byValueKey('main_page');
      await FlutterDriverUtils.isPresent(context.world.driver, locator);
    },
  );
}

StepDefinitionGeneric ProfilePage() {
return given<FlutterWorld> (
'I am on the profile page',
(context) async {
final locator = find.byValueKey('profile_page');
await FlutterDriverUtils.isPresent(context.world.driver, locator);
},
);
}