# 🌿 FarmNet — Offline-First Crop Disease Detection & Advisory

An Android app that lets a farmer **photograph a crop leaf and instantly learn
which disease it has**, with symptoms, prevention and management advice — working
**100% offline**, with no internet needed. Built for rural communities.

> Major Project — Batch 13, Dept. of CSE, Santhiram Engineering College.
> Packaged by **Mind Script Solutions** (www.mindscriptsolutions.in).

---

## What it does

- 📷 Capture a leaf photo (camera or gallery)
- 🧠 A lightweight deep-learning model (**ResNet18 / PlantVillage, 39 classes**)
  runs **on the phone** using **TensorFlow Lite** — no server, no internet
- ✅ Shows the predicted disease + a **confidence score**
- 📋 Gives **symptoms, prevention and management** from a bundled offline
  knowledge base
- 🗂️ Saves every diagnosis to **local history** (offline SQLite database)
- 🌐 UI available in **English, Telugu and Hindi**

Everything the app needs ships inside the APK, so it keeps working in fields
with no mobile network.

---

## 🚀 How to get the installable APK (no laptop build needed)

You do **not** need Android Studio or a powerful laptop. GitHub builds the APK
for you in the cloud.

1. Create a **free GitHub account** (if you don't have one): https://github.com
2. Create a **new empty repository**, e.g. `farmnet`.
3. Upload this whole project folder to it (drag-and-drop on the GitHub website
   works, or use `git push` — see below).
4. GitHub automatically starts building. Open the **Actions** tab → click the
   latest run → wait for the green tick (~5–8 minutes).
5. In that run, scroll down to **Artifacts** → download **`FarmNet-APK`**.
6. Unzip it → copy `FarmNet.apk` to your Android phone → tap to install
   (allow "install from unknown sources" when prompted).

That's it — the app now works offline on your phone.

### Pushing with git (optional)

```bash
git init
git add .
git commit -m "FarmNet initial version"
git branch -M main
git remote add origin https://github.com/<your-username>/farmnet.git
git push -u origin main
```

To rebuild the APK later, just push any change — a fresh APK appears under
Actions → Artifacts every time.

---

## 🧑‍💻 Opening the code (VS Code)

The full source is a standard **Flutter** project you can open in VS Code:

```
lib/                     → all the Dart app code
  main.dart              → app entry point + theme
  models/                → data classes (Prediction, DiagnosisRecord)
  services/
    classifier.dart      → on-device TFLite inference (offline AI)
    knowledge_base.dart  → loads the offline advisory JSON
    history_db.dart      → local SQLite history
    app_locale.dart      → English / Telugu / Hindi strings
  screens/               → Home, Result, History screens
assets/
  models/plant_disease.tflite   → the trained offline model
  data/labels.txt               → 39 class labels
  data/knowledge_base.json      → symptoms / prevention / management
.github/workflows/build-apk.yml → cloud APK build
```

### To run it on your own machine (only if you want to)

```bash
flutter pub get
flutter create --platforms=android --org com.mindscriptsolutions --project-name farmnet .
flutter run        # with a phone/emulator connected
```

(The `flutter create` step regenerates the Android folder, which is not stored
in git — the cloud build does this automatically.)

---

## 🔬 Model details

| Item          | Value                                              |
| ------------- | -------------------------------------------------- |
| Architecture  | ResNet18 (CNN)                                      |
| Dataset       | PlantVillage (38 disease/healthy classes + background) |
| Classes       | 39                                                 |
| Input         | 224×224 RGB, ImageNet-normalised                   |
| Output        | Softmax probability over 39 classes                |
| Runtime       | TensorFlow Lite, on-device (CPU), fully offline     |
| Model size    | ~11 MB (quantized)                                 |

Supported crops: Apple, Blueberry, Cherry, Corn/Maize, Grape, Orange, Peach,
Pepper, Potato, Raspberry, Soybean, Squash, Strawberry and Tomato.

---

## 🛣️ Optional future work (matches the abstract's "when internet is available")

- Cloud sync of saved diagnoses
- Automatic advisory updates
- Expert consultation / tele-advisory
- Fully translated advisory text (symptoms/prevention) in regional languages
  (the UI is already multilingual)

---

## Credits

- Base training/export code & model: PlantAi (open-source, PlantVillage).
- App, offline advisory knowledge base, multilingual UI and cloud build
  pipeline: assembled for this project.
