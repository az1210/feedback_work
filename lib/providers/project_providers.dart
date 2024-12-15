import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

class ProjectService {
  final FirebaseFirestore _firestore;

  ProjectService(this._firestore);

  /// Create a project and link it to the creator
  Future<void> createProject({
    required String userId, // The ID of the user creating the project
    required String projectName,
    required String problemName,
    required String solutionName,
    String? solutionFunctionName,
    String? projectDescription,
    String? youtubeLink,
    String? imageUrl,
  }) async {
    try {
      // Fetch user details from the `users` collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception("User not found");
      }

      final userData = userDoc.data()!;

      // Create the project document in the `projects` collection
      final projectData = {
        'projectName': projectName,
        'problemName': problemName,
        'solutionName': solutionName,
        'solutionFunctionName': solutionFunctionName,
        'projectDescription': projectDescription,
        'youtubeLink': youtubeLink,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'creatorId': userId,
        'creatorDetails': {
          'username': userData['username'],
          'title': userData['title'],
          'expertise': userData['expertise'],
        },
      };

      // if (solutionFunctionName != null && solutionFunctionName.isNotEmpty) {
      //   projectData['solutionFunctionName'] = solutionFunctionName;
      // }
      // if (imageUrl == null) {
      //   projectData.remove('imageUrl');
      // }
      // if (solutionFunctionName != null && solutionFunctionName.isNotEmpty) {
      //   projectData['solutionFunctionName'] = solutionFunctionName;
      // }
      projectData.removeWhere((key, value) => value == null);

      final projectId = _firestore.collection('projects').doc().id;
      await _firestore.collection('projects').doc(projectId).set(projectData);
    } catch (e) {
      throw Exception("Failed to create project: ${e.toString()}");
    }
  }

  /// Fetch all projects sorted by creation time
  Future<List<Map<String, dynamic>>> fetchAllProjects() async {
    try {
      final querySnapshot = await _firestore
          .collection('projects')
          .orderBy('createdAt', descending: true)
          .get();

      // Return a list of project data
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Failed to fetch projects: ${e.toString()}");
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserProjects(
      String userId) {
    return _firestore
        .collection('projects')
        .where('creatorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  /// Fetch projects filtered by a specific expertise
  Future<List<Map<String, dynamic>>> fetchProjectsByExpertise(
      String expertise) async {
    try {
      final querySnapshot = await _firestore
          .collection('projects')
          .where('creatorDetails.expertise', isEqualTo: expertise)
          .orderBy('createdAt', descending: true)
          .get();

      // Return filtered projects as a list
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch projects by expertise: ${e.toString()}");
    }
  }

  /// Fetch paginated projects
  Future<List<Map<String, dynamic>>> fetchProjectsPaginated({
    required int limit,
    DocumentSnapshot?
        lastDocument, // For pagination: last document from previous fetch
  }) async {
    try {
      // Base query
      Query query =
          _firestore.collection('projects').orderBy('createdAt').limit(limit);

      // Add pagination if lastDocument is provided
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Fetch projects
      final querySnapshot = await query.get();

      // Return the project data
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch paginated projects: ${e.toString()}");
    }
  }

  // Update Projects

  Future<void> updateProject({
    required String projectId,
    String? projectName,
    String? problemName,
    String? solutionName,
    String? solutionFunctionName,
    String? projectDescription,
    String? youtubeLink,
    String? imageUrl,
  }) async {
    try {
      // Check if the project exists
      final projectDoc =
          await _firestore.collection('projects').doc(projectId).get();
      if (!projectDoc.exists) {
        throw Exception("Project not found");
      }

      // Prepare updated data
      Map<String, dynamic> updatedData = {};
      if (projectName != null) updatedData['projectName'] = projectName;
      if (problemName != null) updatedData['problemName'] = problemName;
      if (solutionName != null) updatedData['solutionName'] = solutionName;
      if (solutionFunctionName != null) {
        updatedData['solutionFunctionName'] = solutionFunctionName;
      }
      if (projectDescription != null) {
        updatedData['projectDescription'] = projectDescription;
      }
      if (youtubeLink != null) updatedData['youtubeLink'] = youtubeLink;
      if (imageUrl != null) updatedData['imageUrl'] = imageUrl;

      // Update the project document
      await _firestore
          .collection('projects')
          .doc(projectId)
          .update(updatedData);
    } catch (e) {
      throw Exception("Failed to update project: ${e.toString()}");
    }
  }

  // Delete Projects

  Future<void> deleteProject({required String projectId}) async {
    try {
      // Check if the project exists
      final projectDoc =
          await _firestore.collection('projects').doc(projectId).get();
      if (!projectDoc.exists) {
        throw Exception("Project not found");
      }

      // Delete the project document
      await _firestore.collection('projects').doc(projectId).delete();
    } catch (e) {
      throw Exception("Failed to delete project: ${e.toString()}");
    }
  }
}

// Expose ProjectService as a provider
final projectServiceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ProjectService(firestore);
});
