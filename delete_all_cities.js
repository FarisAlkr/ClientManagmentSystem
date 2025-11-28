const admin = require('firebase-admin');

async function deleteAllCities() {
  const serviceAccount = require('./serviceAccountKey.json');
  
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

  const db = admin.firestore();
  
  console.log('🔄 Fetching all cities...');
  
  const citiesSnapshot = await db.collection('cities').get();
  
  console.log(`Found ${citiesSnapshot.size} cities`);
  
  if (citiesSnapshot.size === 0) {
    console.log('No cities to delete');
    process.exit(0);
  }

  // Delete in batches of 500
  const batches = [];
  let batch = db.batch();
  let count = 0;

  citiesSnapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
    count++;
    
    if (count === 500) {
      batches.push(batch);
      batch = db.batch();
      count = 0;
    }
  });

  if (count > 0) {
    batches.push(batch);
  }

  console.log(`🔄 Deleting ${citiesSnapshot.size} cities in ${batches.length} batches...`);

  for (let i = 0; i < batches.length; i++) {
    await batches[i].commit();
    console.log(`✅ Batch ${i + 1}/${batches.length} committed`);
  }

  console.log('✅ All cities deleted successfully!');
  process.exit(0);
}

deleteAllCities().catch(error => {
  console.error('❌ Error:', error);
  process.exit(1);
});
