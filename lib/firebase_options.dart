import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmTL1zlv1M4FsnRkDZQqe9LzTqQlulEQY',
    appId: '1:90367474956:android:47f75be6fc8d327b729d29',
    messagingSenderId: '90367474956',
    projectId: 'homigo-care-8360e',
    databaseURL: 'https://homigo-care-8360e-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrcPI8ReNNKhsi6Kcn5Qeux4sgl5adp7E',
    appId: '1:90367474956:web:e0eb4e4e6be00b9e729d29',
    messagingSenderId: '90367474956',
    projectId: 'homigo-care-8360e',
    databaseURL: 'https://homigo-care-8360e-default-rtdb.firebaseio.com',
    storageBucket: 'homigo-care-8360e.firebasestorage.app',
    authDomain: 'homigo-care-8360e.firebaseapp.com',
    measurementId: 'G-MTT78YH41R',
  );
}
