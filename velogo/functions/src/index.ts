/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";

admin.initializeApp();

// Cloud Function для перевірки доступності email
export const checkEmailAvailability = functions.https.onCall(
  async (request) => {
    const email = request.data.email; // Доступ до даних запиту через `data`

    // Перевірка коректності email
    if (!email || typeof email !== "string") {
      throw new functions.https.HttpsError("invalid-argument", "Invalid email address");
    }

    try {
      // Використовуємо Firebase Authentication для перевірки наявності користувача з таким email
      await admin.auth().getUserByEmail(email);

      // Якщо користувач знайдений
      return { available: false, message: "This email is already taken." };
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        // Якщо користувач не знайдений, email доступний
        functions.logger.info("Email is available: ", { email });
        return { available: true, message: "Email is available!" };
      } else {
        // Обробка інших помилок
        // console.error("Error checking email:", error);
        functions.logger.error("Error checking email:", error);
        throw new functions.https.HttpsError("internal", "Error checking email");
      }
    }
  }
);

