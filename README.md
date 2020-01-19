# react-native-apple-signin

React-Native module that provides basic **Apple SignIn** authorization for your app

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

