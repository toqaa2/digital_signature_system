const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.updateUserPassword = functions.https.onRequest(async (req, res) => {
  // Check for POST request
  if (req.method !== 'POST') {
    return res.status(405).send('Method Not Allowed');
  }

  // Extract UID and newPassword from the request body
  const { uid, newPassword } = req.body;

  if (!uid || !newPassword) {
    return res.status(400).send('Missing uid or newPassword');
  }

  try {
    // Update the user's password
    await admin.auth().updateUser(uid, {
      password: newPassword,
    });

    // Send success response
    res.status(200).send('Password updated successfully');
  } catch (error) {
    console.error('Error updating user password:', error);
    res.status(500).send('Error updating password');
  }
});