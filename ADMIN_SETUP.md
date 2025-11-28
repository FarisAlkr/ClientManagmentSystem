# 🔥 Firebase Admin Setup Instructions

## Quick Setup (3 steps)

### Step 1: Get Service Account Key
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click **⚙️ Settings** → **Project Settings**
4. Go to **Service Accounts** tab
5. Click **"Generate New Private Key"**
6. Save the downloaded file as `serviceAccountKey.json` in this directory

### Step 2: Create Admin Account
1. Open your Flutter app
2. Register a new account with your admin email
3. The account will be in "pending" status - this is normal

### Step 3: Run Setup Script
```bash
npm run setup-admin
```

The script will:
- ✅ Connect to Firebase
- ✅ Find your user account
- ✅ Set admin custom claims
- ✅ Verify the setup

## After Setup

**Test Admin Login:**
1. Go to `/admin-login` in your app
2. Login with your admin email/password
3. You should access the admin panel successfully!

## Troubleshooting

**❌ "Service account key not found"**
- Make sure `serviceAccountKey.json` is in the project root
- Check the file isn't corrupted

**❌ "User not found"**
- The user must register in the app first
- Check you're using the correct email

**❌ "Permission denied"**
- Make sure your service account has Admin SDK permissions
- Re-download the service account key

## Security Notes

⚠️ **NEVER commit `serviceAccountKey.json` to version control!**

Add to `.gitignore`:
```
serviceAccountKey.json
node_modules/
```

## Manual Verification

Check if admin claims are set:
```dart
final user = FirebaseAuth.instance.currentUser;
final idTokenResult = await user!.getIdTokenResult();
print('Admin: ${idTokenResult.claims?['admin']}'); // Should be true
```

---

**🎉 Once setup is complete, your admin panel is fully secure and functional!**