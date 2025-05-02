import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref("users");
  final _auth = FirebaseAuth.instance;

  // Rating values
  double _accomodationRating = 0;
  double _swagsRating = 0;
  double _commEmailRating = 0;
  double _venueRating = 0;
  double _foodRating = 0;
  double _activitiesRating = 0;
  double _mentorRating = 0;
  double _teamRating = 0;
  double _speakersRating = 0;
  double _closingRating = 0;

  // Text controllers
  final _roundsFeedbackController = TextEditingController();
  final _improvementController = TextEditingController();
  final _enjoyedController = TextEditingController();

  bool _isSubmitting = false;
  bool _hasSubmittedFeedback = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPreviousSubmission();
  }

  Future<void> _checkPreviousSubmission() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Check if the user has already submitted feedback
      DatabaseEvent event = await _database.child(uid).child('feedback').once();

      setState(() {
        _hasSubmittedFeedback = event.snapshot.exists;
        _isLoading = false;
      });

      // If feedback exists, load it for display or edit
      if (_hasSubmittedFeedback && event.snapshot.value != null) {
        _loadExistingFeedback(event.snapshot.value as Map);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadExistingFeedback(Map feedbackData) {
    try {
      // Extract ratings
      Map<dynamic, dynamic> ratings = (feedbackData['ratings'] as Map);
      Map<dynamic, dynamic> comments = (feedbackData['comments'] as Map);

      setState(() {
        _accomodationRating = ratings['accomodation'] ?? 0;
        _swagsRating = ratings['swags'] ?? 0;
        _commEmailRating = ratings['commEmail'] ?? 0;
        _venueRating = ratings['venue'] ?? 0;
        _foodRating = ratings['food'] ?? 0;
        _activitiesRating = ratings['activities'] ?? 0;
        _mentorRating = ratings['mentor'] ?? 0;
        _teamRating = ratings['team'] ?? 0;
        _speakersRating = ratings['speakers'] ?? 0;
        _closingRating = ratings['closing'] ?? 0;

        _roundsFeedbackController.text = comments['roundsFeedback'] ?? '';
        _improvementController.text = comments['areasForImprovement'] ?? '';
        _enjoyedController.text = comments['enjoyed'] ?? '';
      });
    } catch (e) {
      print("Error loading feedback: $e");
    }
  }

  @override
  void dispose() {
    _roundsFeedbackController.dispose();
    _improvementController.dispose();
    _enjoyedController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _validateRatings()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Get current user
        User? currentUser = _auth.currentUser;

        if (currentUser == null) {
          throw Exception("No user is signed in");
        }

        // Use the current user's UID
        String uid = currentUser.uid;

        // Check if user has already submitted feedback
        DatabaseEvent event = await _database.child(uid).child('feedback').once();

        if (event.snapshot.exists) {
          throw Exception("You have already submitted feedback");
        }

        // Store feedback under the user's UID
        await _database.child(uid).child('feedback').set({
          'timestamp': ServerValue.timestamp,
          'ratings': {
            'accomodation': _accomodationRating,
            'swags': _swagsRating,
            'commEmail': _commEmailRating,
            'venue': _venueRating,
            'food': _foodRating,
            'activities': _activitiesRating,
            'mentor': _mentorRating,
            'team': _teamRating,
            'speakers': _speakersRating,
            'closing': _closingRating,
          },
          'comments': {
            'roundsFeedback': _roundsFeedbackController.text,
            'areasForImprovement': _improvementController.text,
            'enjoyed': _enjoyedController.text,
          }
        });

        setState(() {
          _hasSubmittedFeedback = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    } else if (!_validateRatings()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide a rating for all categories'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _validateRatings() {
    return _accomodationRating > 0 &&
        _swagsRating > 0 &&
        _commEmailRating > 0 &&
        _venueRating > 0 &&
        _foodRating > 0 &&
        _activitiesRating > 0 &&
        _mentorRating > 0 &&
        _teamRating > 0 &&
        _speakersRating > 0 &&
        _closingRating > 0;

  }

  void _resetForm() {
    setState(() {
      _accomodationRating = 0;
      _swagsRating = 0;
      _commEmailRating = 0;
      _venueRating = 0;
      _foodRating = 0;
      _activitiesRating = 0;
      _mentorRating = 0;
      _teamRating = 0;
      _speakersRating = 0;
      _closingRating = 0;
      _roundsFeedbackController.clear();
      _improvementController.clear();
      _enjoyedController.clear();
    });
    _formKey.currentState?.reset();
  }

  Widget _buildRatingSection(String title, double rating, Function(double) onRatingUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                rating > 0 ? rating.toStringAsFixed(1) : '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: RatingBar.builder(
              initialRating: rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              unratedColor: Colors.grey[300],
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: _hasSubmittedFeedback
                  ? (_) {} // Disable updates if already submitted
                  : onRatingUpdate,
              ignoreGestures: _hasSubmittedFeedback, // Disable interaction if already submitted
            ),
          ),
          Divider(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Trikon Event Feedback'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trikon Event Feedback',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isSubmitting
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Submitting your feedback...'),
            ],
          ),
        )
            : Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeaderCard(),
              if (_hasSubmittedFeedback)
                _buildSubmittedMessage()
              else
                Container(),
              const SizedBox(height: 20),
              _buildRatingsCard(),
              const SizedBox(height: 20),
              _buildDetailsCard(),
              const SizedBox(height: 24),
              if (!_hasSubmittedFeedback) _buildSubmitButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmittedMessage() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              'You have already submitted feedback!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for your valuable input. You can view your responses below.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.feedback_rounded,
              size: 50,
              color: Colors.indigo,
            ),
            const SizedBox(height: 8),
            Text(
              'Your Opinion Matters!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please share your thoughts about the Trikon event to help us improve.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How Satisfied were you with the following?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            _buildRatingSection(
              'Accomodation',
              _accomodationRating,
                  (rating) => setState(() => _accomodationRating = rating),
            ),
            _buildRatingSection(
              'Swags',
              _swagsRating,
                  (rating) => setState(() => _swagsRating = rating),
            ),
            _buildRatingSection(
              'Communication Emails',
              _commEmailRating,
                  (rating) => setState(() => _commEmailRating = rating),
            ),
            _buildRatingSection(
              'Venue',
              _venueRating,
                  (rating) => setState(() => _venueRating = rating),
            ),
            _buildRatingSection(
              'Food',
              _foodRating,
                  (rating) => setState(() => _foodRating = rating),
            ),
            _buildRatingSection(
              'Activities',
              _activitiesRating,
                  (rating) => setState(() => _activitiesRating = rating),
            ),
            _buildRatingSection(
              'Mentor Support',
              _mentorRating,
                  (rating) => setState(() => _mentorRating = rating),
            ),
            _buildRatingSection(
              'Team Intellia',
              _teamRating,
                  (rating) => setState(() => _teamRating = rating),
            ),
            _buildRatingSection(
              'Speakers',
              _speakersRating,
                  (rating) => setState(() => _speakersRating = rating),
            ),
            _buildRatingSection(
              'Closing Ceremony',
              _closingRating,
                  (rating) => setState(() => _closingRating = rating),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Feedback on Event Rounds',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _roundsFeedbackController,
              decoration: InputDecoration(
                hintText: 'Share your thoughts about the different rounds...',
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 3,
              readOnly: _hasSubmittedFeedback, // Make read-only if already submitted
            ),
            const SizedBox(height: 20),

            Text(
              'What did you enjoy the most?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _enjoyedController,
              decoration: InputDecoration(
                hintText: 'Tell us about your favorite parts...',
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 3,
              readOnly: _hasSubmittedFeedback, // Make read-only if already submitted
            ),
            const SizedBox(height: 20),

            Text(
              'Areas for Improvement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _improvementController,
              decoration: InputDecoration(
                hintText: 'What could we do better next time?',
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 3,
              readOnly: _hasSubmittedFeedback, // Make read-only if already submitted
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _hasSubmittedFeedback ? null : _submitFeedback,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'SUBMIT FEEDBACK',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}