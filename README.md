# react-native-apple-signin-module

React-Native module that provides basic **Apple SignIn** authorization for your app

## Getting started

`$ npm install react-native-apple-signin-module --save`

### Mostly automatic installation

`$ react-native link react-native-apple-signin-module`

`$ cd ios && pod install`

* open your project in Xcode and in Explorer click on your project root folder, then select tab **Signing & Capabilities**,
then click on **+ Capability** and start typing **Sign In with Apple**, add by double clicking.

## Usage
```javascript
import AppleSignin from 'react-native-apple-signin-module';

// setup listener for signin events:
AppleSignIn.onSignIn(c => {
  console.log('- c =>', c)

  // after user signin - you will receive object, something like this: 
  // { 
  //   uid: '023..', 
  //   email: 'some@email.com',
  //   nick: 'nickname',
  //   givenName: 'Mike',
  //   familyName: 'West'
  // }

})

// perform signin request (uid = '', because we dont know it yet)
AppleSignIn.signIn('', c => {
console.log('- signIn() method callback ->', c)
})
```
* next time you can use provided `uid` to sign in faster using `signIn(uid, ..` 

