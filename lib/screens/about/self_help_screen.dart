import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/constants/constant.dart';
import 'package:outpatient_department/widgets/app_bar.dart';
import 'package:outpatient_department/widgets/drawer.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class SelfHelpScreen extends StatefulWidget {
  const SelfHelpScreen({super.key});

  @override
  State<SelfHelpScreen> createState() => _SelfHelpScreenState();
}

class _SelfHelpScreenState extends State<SelfHelpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;
  final box = GetStorage();

  final Map<String, List<String>> selfHelpContent = {
    "Appointments": [
      "How to book an appointment for a new patient?",
      "How to book an appointment for an existing patient?",
      "How to book an appointment with ABHA?",
      "How to update patient details when adding an appointment?",
      "How to reschedule or cancel an appointment?",
      "How to view the daily visit list?",
      "How to view upcoming visit list?",
      "How to view past visit list?",
    ],
    "Patients": [
      "How to search for a patient and see their complete medical record?",
      "How to view patient records via ABDM?",
    ],
    "Bills": [
      "How to pay a pending bill?",
      "How to access patient bills?",
      "How to check pending payments for the day?",
    ],
    "ABHA": [
      "How to create ABHA for new patients?",
      "How to link a patient’s existing ABHA with an appointment?",
      "How to link ABHA for a completed consultation?",
    ],
    "EMR (Electronic Medical Record)": [
      "How to upload an Rx and complete a consultation?",
      "How to add clinical notes and complete a consultation?",
      "How to consult using the Voice analyzer?",
      "How to view prescription or consultation information for the patient?",
      "How to send prescription or consultation information to the patient via WhatsApp?",
      "How to create pre-set prescription templates?",
      "How to create test recommendation lists?",
    ],
    "Teleconsultation": [
      "How to add and complete a tele-consult?",
      "How to enable tele-consultation?",
    ],
    "Settings": [
      "How to change account password?",
      "How to change account PIN?",
      "How to consult in multiple clinics?",
      "How to switch between clinics?",
      "How to set the primary consultation type?",
      "How to setup biometric login?",
    ],
    "MIS (Management Information System)": [
      "How to check clinic insights?",
    ],
  };

  // Method to show the video player in a dialog
  void _showVideoDialog(String videoUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing the dialog by tapping outside
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: VideoPlayerDialog(videoUrl: videoUrl),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: CustomAppBar(
        doctorName: Constant.doctorname,
        clinicName: Constant.clinicName,
        scaffoldKey: _scaffoldKey,
        isABDMEnabled: isABDMEnabled,
        onRefresh: (bool value){
          /*setState(() {
            searchFlag = !searchFlag;
          });*/
        },
      ),
      drawer: ArgonDrawer(currentPage: Constant.help),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Self Help Content
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ListView.separated(
                  itemCount: selfHelpContent.entries.length,
                  separatorBuilder: (context, index) => Divider(
                    color: ArgonColors.muted, // Custom color for the divider
                    thickness: 1.0, // Divider thickness
                    height: 10.0, // Space between the tiles
                  ),
                  itemBuilder: (context, index) {
                    final entry = selfHelpContent.entries.elementAt(index);
                    return ExpansionTile(
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: ArgonColors.primary,
                        ),
                      ),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: entry.value.map((item) {
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.play_circle_outline_sharp),
                            onPressed: () {
                              _showVideoDialog('https://connectstaging.medixcel.in/self_help_videos/How_to_book_an_appointment_for_a_new_patient.mp4');
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            // // Elevated Button at the Bottom
            // Padding(
            //   padding: const EdgeInsets.only(top: 16.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       _showVideoDialog('https://connectstaging.medixcel.in/self_help_videos/How_to_book_an_appointment_for_a_new_patient.mp4');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: ArgonColors.primary,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       minimumSize: Size(100, 50), // Width: 100, Height: 50
            //     ),
            //     child: Text(
            //       'Video',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerDialog({required this.videoUrl, super.key});

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // Video Player
          Expanded(
            child: _videoPlayerController.value.isInitialized
                ? Chewie(
              controller: _chewieController,
            )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
