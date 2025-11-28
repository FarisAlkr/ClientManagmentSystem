const admin = require('firebase-admin');

async function checkCommittees() {
  const serviceAccount = require('./serviceAccountKey.json');
  
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
  }

  const db = admin.firestore();
  
  console.log('🔄 Fetching all committees...');
  
  const committeesSnapshot = await db.collection('committees').get();
  
  console.log(`Found ${committeesSnapshot.size} committees`);
  
  if (committeesSnapshot.size > 0) {
    console.log('\nCommittees:');
    committeesSnapshot.docs.forEach((doc, index) => {
      const data = doc.data();
      console.log(`${index + 1}. ${data.name} (ID: ${doc.id})`);
    });
  }
  
  process.exit(0);
}

checkCommittees().catch(error => {
  console.error('❌ Error:', error);
  process.exit(1);
});
