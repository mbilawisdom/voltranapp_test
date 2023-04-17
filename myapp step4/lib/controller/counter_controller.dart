import 'package:get/get.dart';

import '../model/count_model.dart';

class CounterController extends GetxController {
  var counter = 0.obs;

  var displayCounter = 0.obs;

  var isRunning = false.obs;

  var currentTime;

  var countList = <CountModel>[].obs;
  var additionalCountList = <CountModel>[].obs;
  var previousCountDate = DateTime.now().obs;

  void incrementCounterAndAddToList() {
    var dateTimeNow = DateTime.now();

    // increment counter
    counter.value++;

    // subtract current time from previousCount time
    currentTime =
        dateTimeNow.difference(previousCountDate.value).inMilliseconds;

    // check if count is == 1 which is the first count when click then set time to 0 milliseconds
    if (counter.value == 1) {
      countList.value.add(CountModel(count: counter.value, time: 0));

      previousCountDate.value = dateTimeNow;
      return;
    }

    if (isRunning.value == true) {
      additionalCountList.value
          .add(CountModel(count: counter.value, time: currentTime));

      previousCountDate.value = dateTimeNow;
      return;
    }

    countList.add(CountModel(count: counter.value, time: currentTime));

    previousCountDate.value = dateTimeNow;
  }

  Future<void> listCounts() async {
    for (var element in countList) {
      isRunning.value = true;

      await Future.delayed(Duration(milliseconds: element.time!))
          .whenComplete(() {
        displayCounter.value = element.count!;
      });
    }

    isRunning.value = false;
    countList.clear();
  }

  Future<void> displayCounterListitem() async {
    await listCounts();
    if (isRunning.value == false && additionalCountList.isNotEmpty) {
      countList.addAll(additionalCountList);
      additionalCountList.clear();

      await displayCounterListitem();

      return;
    }

    await Future.delayed(Duration(seconds: 1));

    displayCounter.value = counter.value = 0;
  }
}
