# Firebase Security Configuration

## Огляд

Цей документ описує налаштування безпеки Firebase для проекту Velogo.

## Правила безпеки Firestore

### Поточні правила

Файл: `firestore.rules`

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Дозволити користувачам читати та писати свої дані
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Дозволити користувачам читати та писати свої профільні дані
    match /profiles/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Дозволити користувачам читати та писати свої маршрути
    match /routes/{routeId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }

    // Дозволити користувачам читати та писати свої налаштування
    match /settings/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // За замовчуванням забороняти всі операції
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### Пояснення правил

1. **users/{userId}** - Користувачі можуть читати та писати тільки свої дані
2. **profiles/{userId}** - Користувачі можуть читати та писати тільки свій профіль
3. **routes/{routeId}** - Користувачі можуть читати та писати тільки свої маршрути
4. **settings/{userId}** - Користувачі можуть читати та писати тільки свої налаштування
5. **За замовчуванням** - Всі інші операції заборонені

## Розгортання правил

### Розгортання до продакшену

```bash
firebase deploy --only firestore:rules
```



## Колекції в проекті

### Поточні колекції

1. **users** - Дані користувачів (Auth Feature)
2. **profiles** - Профільні дані користувачів (Profile Feature)

### Майбутні колекції

1. **routes** - Маршрути користувачів (Map Feature)
2. **settings** - Налаштування користувачів (Settings Feature)

## Безпека

### Принципи безпеки

1. **Аутентифікація** - Всі операції потребують аутентифікації
2. **Авторизація** - Користувачі можуть доступ тільки до своїх даних
3. **За замовчуванням заборонено** - Всі операції заборонені за замовчуванням

### Перевірка безпеки

1. Користувач повинен бути аутентифікований (`request.auth != null`)
2. ID користувача повинен співпадати з ID документа (`request.auth.uid == userId`)
3. Для маршрутів перевіряється власник документа (`resource.data.userId`)

## Оновлення правил

При додаванні нових колекцій:

1. Додайте нове правило в `firestore.rules`
2. Протестуйте правило локально
3. Розгорніть правило до продакшену
4. Оновіть цю документацію

## Приклади

### Додавання нової колекції

```javascript
// Дозволити користувачам читати та писати свої коментарі
match /comments/{commentId} {
  allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
}
```

### Складніші правила

```javascript
// Дозволити читати публічні маршрути, але писати тільки свої
match /routes/{routeId} {
  allow read: if resource.data.isPublic == true || request.auth.uid == resource.data.userId;
  allow write: if request.auth != null && request.auth.uid == resource.data.userId;
}
```

## Консоль Firebase

Для перегляду та редагування правил безпеки:

1. Відкрийте [Firebase Console](https://console.firebase.google.com/project/velogo-6e731)
2. Перейдіть до Firestore Database
3. Виберіть вкладку "Rules"
4. Відредагуйте правила та натисніть "Publish"
