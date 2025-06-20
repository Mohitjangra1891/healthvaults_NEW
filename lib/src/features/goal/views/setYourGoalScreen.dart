import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/common/views/widgets/logoWithTextNAme.dart';
import 'package:healthvaults/src/features/goal/views/widgets/difficulty_Buttton.dart';
import 'package:healthvaults/src/res/appColors.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:lottie/lottie.dart';

import '../../../res/const.dart';
import '../../../utils/prompt.dart';
import '../../healthTab/controller/planController.dart';
import '../../healthTab/views/widgets/exerciseCard.dart';
import '../../plan/newPlanScreen.dart';
import '../controller/CreatePlanController.dart';
import 'e.dart';
import 'g.dart';

class SetYourGoalScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _SetYourGoalScreenState();
}

class _SetYourGoalScreenState extends ConsumerState<SetYourGoalScreen> with SingleTickerProviderStateMixin {
  final ageController = TextEditingController(text: "22");
  final heightController = TextEditingController(text: "180");
  final weightController = TextEditingController(text: "80");
  int selectedDuration = 60;
  String selectedTarget = 'Full body';
  String selectedDifficulty = 'Medium';
  bool warmUp = true;
  bool coolDown = true;
  Set<int> _selectedWeekdays = {1, 3, 4, 5};

  String getSelectedDaysString() {
    List<String> weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return _selectedWeekdays.map((day) => weekdays[day]).join(', ');
  }

  List<String> _equipment = [];
  String workoutLocation = '';
  final selectedGoals = <String>{};
  double weightLossGoal = 7;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool showDetails = true;
  bool isLoading = false;

  // bool hasGeneratedPlan = false;
  bool showPlan = false;
  String buttonText = "Show my personalized plan";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(CreatePlan_Provider_Controller.notifier).initChatSession();
    });
  }

  void toggleGoal(String goal) {
    setState(() {
      showPlan = false;
      buttonText = "Show my personalized plan";

      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
        if (goal == 'Lose Weight') _animationController.reverse();
      } else {
        selectedGoals.add(goal);
        if (goal == 'Lose Weight') _animationController.forward();
      }
    });
  }

  void _toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  String getPrompt({
    int? type,
    required String age,
    required String height,
    required String weight,
    required String gender,
    required String place,
    required String goals,
  }) {
    switch (type) {
      // case 0:
      //   return "Can you please generate again with some changes, I don't like it, response structure will be same";
      case 1:
        return "Can you please make it easier? Respond with the same JSON structure only, no explanation or formatting.";
      case 2:
        return "Can you please make it harder? Respond with the same JSON structure only, no explanation or formatting.";
      default:
        // return prompt.getPromt(age: age, height: height, weight: weight, gender: gender, place: place, goals: goals);
        return prompt.getPromt1(
            age: age,
            height: height,
            weight: weight,
            gender: gender,
            place: place,
            goals: goals,
            level: '',
            equipments: '',
            days: getSelectedDaysString(),
            time: "${selectedDuration}mins");
    }
  }

  void _loadPlan({int? type}) async {
    setState(() {
      buttonText = "Show my personalized plan";
      showDetails = false;
      // hasGeneratedPlan = false;
      isLoading = true;
      showPlan = true;
    });

    final goalText = Constants.getGoalText(selectedGoals, weightLossGoal);

    final prompt = getPrompt(
        type: type,
        place: workoutLocation,
        age: ageController.text.trim(),
        gender: "male",
        height: heightController.text.trim(),
        weight: weightController.text.trim(),
        goals: goalText);

    print("prompt =$prompt");
    await ref.read(CreatePlan_Provider_Controller.notifier).fetchPlan(prompt: prompt);
    setState(() {
      // hasGeneratedPlan = true;
      showPlan = true;
      isLoading = false;
      buttonText = "Generate Again";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;

    InputDecoration numberFieldDecoration() => InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        // no shadow on scroll
        backgroundColor: isDark ? CupertinoColors.black : Colors.white,
        automaticallyImplyLeading: false,
        title: Text('Set Your Goal', style: TextStyle(color: borderColor, fontWeight: FontWeight.w600, fontSize: 28)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: borderColor),
            onPressed: _toggleDetails,
            child: Row(
              children: [
                Text(showDetails ? "Hide Details" : "Show Details", style: TextStyle(color: !isDark ? Colors.white : AppColors.primaryColor)),
                Icon(showDetails ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up,
                    color: !isDark ? Colors.white : AppColors.primaryColor)
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                // padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: showDetails
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 32),

                              Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? Colors.grey[800]! : Colors.white!,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Age', style: TextStyle(fontSize: 18)),
                                                SizedBox(height: 2),
                                                TextField(
                                                  onTapOutside: (PointerDownEvent) {
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  controller: ageController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: numberFieldDecoration().copyWith(hintText: "years"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Height', style: TextStyle(fontSize: 18)),
                                                SizedBox(height: 2),
                                                TextField(
                                                  onTapOutside: (PointerDownEvent) {
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  controller: heightController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: numberFieldDecoration().copyWith(hintText: "cm"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Weight', style: TextStyle(fontSize: 18)),
                                                SizedBox(height: 2),
                                                TextField(
                                                  onTapOutside: (PointerDownEvent) {
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  controller: weightController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: numberFieldDecoration().copyWith(hintText: "kg"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 32),
                              Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? Colors.grey[800]! : Colors.white!,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TrainingDurationSelector(
                                        selected: selectedDuration,
                                        onChanged: (val) => setState(() => selectedDuration = val),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? Colors.grey[800]! : Colors.white!,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DifficultySelector(
                                        selected: selectedDifficulty,
                                        onChanged: (val) => setState(() => selectedDifficulty = val),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? Colors.grey[800]! : Colors.white!,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('WEEKLY SCHEDULE', style: Theme.of(context).textTheme.labelLarge),
                                      const SizedBox(height: 8),
                                      WeekdaySelector(
                                        selectedIndices: _selectedWeekdays,
                                        onChanged: (days) => setState(() => _selectedWeekdays = days),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? Colors.grey[800]! : Colors.white!,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('WORKOUT LOCATION', style: Theme.of(context).textTheme.labelLarge?.copyWith()),
                                      SizedBox(height: 8),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        spacing: 10,
                                        children: [
                                          Expanded(
                                            child: buildSelectableOption2('Home', CupertinoIcons.home, workoutLocation == 'Home',
                                                () => setState(() => workoutLocation = 'Home')),
                                          ),
                                          // SizedBox(width: screenWidth * 0.12),
                                          Expanded(
                                              child: buildSelectableOption2('Gym', Icons.fitness_center, workoutLocation == 'Gym',
                                                  () => setState(() => workoutLocation = 'Gym'))),
                                        ],
                                      ),

                                      // LocationPicker(
                                      //   selected: workoutLocation,
                                      //   onChanged: (loc) => setState(() => workoutLocation = loc),
                                      // ),

                                      // only show equipments if “home”:
                                      if (workoutLocation == 'Home') ...[
                                        const SizedBox(height: 24),
                                        Text('Equipments available at home:'),
                                        EquipmentSelector(
                                          allItems: ['Yoga Mat', 'Resist Band', 'Skipping Rope', 'Hand Weights'],
                                          onChanged: (lst) => setState(() => _equipment = lst),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                              Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? Colors.grey[800]! : Colors.white!,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('YOUR GOAL', style: Theme.of(context).textTheme.labelLarge?.copyWith()),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          buildSelectableOption(
                                            'Lose Weight',
                                            appImages.weightLoss,
                                            selectedGoals.contains('Lose Weight'),
                                            () => toggleGoal('Lose Weight'),
                                          ),
                                          buildSelectableOption(
                                            'Build Strength',
                                            appImages.strength,
                                            selectedGoals.contains('Strength Gain'),
                                            () => toggleGoal('Strength Gain'),
                                          ),
                                          buildSelectableOption(
                                            'Improve Flexibility',
                                            appImages.flexibility,
                                            selectedGoals.contains('flexibility'),
                                            () => toggleGoal('flexibility'),
                                          ),
                                        ],
                                      ),
                                      SizeTransition(
                                        sizeFactor: _fadeAnimation,
                                        axisAlignment: -1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 24),
                                            Text("What's your total weight loss goal: ${weightLossGoal.toInt()} kg",
                                                style: TextStyle(color: textColor)),
                                            Slider(
                                              value: weightLossGoal,
                                              min: 2,
                                              max: 25,
                                              activeColor: borderColor,
                                              onChanged: (val) => setState(() => weightLossGoal = val),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),
                              // TargetAreaSelector(
                              //   selected: selectedTarget,
                              //   onChanged: (val) => setState(() => selectedTarget = val),
                              // ),
                              // SizedBox(height: 32),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              //   margin: const EdgeInsets.symmetric(horizontal: 4),
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey.withOpacity(0.2),
                              //     borderRadius: BorderRadius.circular(12),
                              //   ),
                              //   child: Column(
                              //     children: [
                              //       ToggleOption(
                              //         title: 'Warm-Up',
                              //         subtitle: '+3-5 minutes before workout',
                              //         value: warmUp,
                              //         onChanged: (val) => setState(() => warmUp = val),
                              //       ),
                              //       Divider(
                              //         color: Colors.grey,
                              //         thickness: 0.5,
                              //         indent: 4,
                              //         endIndent: 4,
                              //       ),
                              //       ToggleOption(
                              //         title: 'Cool Down',
                              //         subtitle: '+3-5 minutes after workout',
                              //         value: coolDown,
                              //         onChanged: (val) => setState(() => coolDown = val),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(height: 32),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.grey[800]! : Colors.white!,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      child: ElevatedButton(
                        onPressed: () {
                          if (ageController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Age should not be empty")),
                            );
                          } else if (heightController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Height should not be empty")),
                            );
                          } else if (weightController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Weight should not be empty")),
                            );
                          } else if (workoutLocation.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please choose a place for workout")),
                            );
                          } else if (selectedGoals.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please choose your goal")),
                            );
                          } else {
                            if (isLoading == false) _loadPlan();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          side: BorderSide(color: borderColor, width: 1.8),
                          minimumSize: Size(screenWidth * 0.80, 50),
                        ),
                        child: Text(buttonText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  showPlan
                      ? SizedBox.shrink()
                      : Text(
                          "Set your long term body transformation target. We'll create a manageable, personalized three months plan as your first milestone.",
                          style: TextStyle(color: textColor),
                        ),

                  // Conditional UI below button
                  if (showPlan)
                    Consumer(
                      builder: (context, ref, _) {
                        final planAsync = ref.watch(CreatePlan_Provider_Controller);

                        return planAsync.when(
                          data: (plan) {
                            if (plan == null) {
                              return const Text("No workout plan available.");
                            }
                            return Column(
                              spacing: 12,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    difficulty_Buttton(
                                      onPressed: () => _loadPlan(type: 1),
                                      title: "Make it Easier",
                                      image: 'assets/svg/arrowDown.svg',
                                      color: Colors.greenAccent,
                                    ),
                                    difficulty_Buttton(
                                      onPressed: () => _loadPlan(type: 2),
                                      title: "Challenge Me More",
                                      image: 'assets/svg/arrowUp.svg',
                                      color: Colors.redAccent,
                                    ),
                                  ],
                                ),
                                Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDark ? Colors.grey[800]! : Colors.white!,
                                  child: SingleChildScrollView(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      // const SizedBox(height: 12),
                                      // Text(
                                      //   "* Kindly go through all exercise before adding.",
                                      //   style: TextStyle(fontWeight: FontWeight.w300),
                                      // ),
                                      // planScreen(
                                      //   workoutPlan: plan!,
                                      // ),
                                      newWorkoutPlanScreen(
                                        plan: plan!,
                                      ),
                                    ]),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ExpandableText(
                                  text: DISCLAIMER,
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 40),
                                logoWithTextName(),
                                const SizedBox(height: 120),
                              ],
                            );
                          },
                          loading: () => Lottie.asset('assets/loading.json'),
                          error: (error, stack) => Center(child: Text("Please Try Again .", style: TextStyle(fontSize: 24))),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          if (showPlan == true)
            Consumer(
              builder: (context, ref, _) {
                final planState = ref.watch(CreatePlan_Provider_Controller);
                return planState.maybeWhen(
                  data: (plan) => plan != null
                      ? Positioned(
                          bottom: 10,
                          left: 16,
                          right: 16,
                          child: ElevatedButton(
                            onPressed: () async {
                              final userId = FirebaseAuth.instance.currentUser!.uid;
                              final updatedPlan = plan.copyWith(startDate: DateTime.now());

                              await ref.read(workoutPlanProvider.notifier).savePlan(
                                updatedPlan,
                                rawModelJson: ref.read(CreatePlan_Provider_Controller.notifier).rawModelJson,
                                prompt: ref.read(CreatePlan_Provider_Controller.notifier).lastPrompt,
                                userId: userId,
                              );

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor: borderColor,
                            ),
                            child: Text("Add This Plan",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: !isDark ? Colors.white : AppColors.primaryColor)),
                          ),
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget buildSelectableOption(String label, String image, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(color: selected ? AppColors.primaryColor : Colors.white10, borderRadius: BorderRadius.circular(8)),
              child: Image.asset(
                image,
                height: 35,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(label)
        ],
      ),
    );
  }

  Widget buildSelectableOption2(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap, {
    String? image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        // margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          spacing: 10,
          children: [
            Icon(icon),
            image != null
                ? Image.asset(
                    image,
                    height: 35,
                  )
                : SizedBox.shrink(),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
