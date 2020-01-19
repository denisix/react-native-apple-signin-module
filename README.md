# react-native-apple-signin

## Getting started

`$ npm install react-native-apple-signin --save`

### Mostly automatic installation

`$ react-native link react-native-apple-signin`

## Usage
```javascript
import AppleSignin from 'react-native-apple-signin';

// setup listener for signin events:
AppleSignIn.onSignIn(c => {
  console.log('- c =>', c)

  // c can contain object with the values: 
  // { uid, email, nick, givenName, familyName }

})

// perform signin request (uid = '', because we dont know it yet)
AppleSignIn.signIn('', c => {
console.log('- signIn() method callback ->', c)
})


// next time we can request signIn() with the previously saved `uid` variable, - the process will take much less time without annoying user
```
