## Deployment guide

### Auth Setup

Create npmrc file in the root directory of the project with the following content:

```
registry=https://registry.npmjs.org/
@flyreel:registry=https://npm.pkg.github.com/
//npm.pkg.github.com/:_authToken=<GITHUB_TOKEN>
```

---

### Deployment Steps

1. _Create Release branch_: Create a new release branch from the main branch with the naming convention `release/vX.X.X`, where `X.X.X` is the new version number.
2. _Update library's version_: Iterate the version number in `flyreel-sdk-react-native.podspec`, `package.json`, and `android/build.gradle` files.
3. _Update Yarn dependencies_: Run `yarn install` to update the dependencies in `yarn.lock` file.
4. _Update Pod dependencies_: Run `pod install` in the `example/ios` directory to update the dependencies in `Podfile.lock` file.
5. _Review Readme_: Review the `README.md` file to ensure that the installation instructions are up to date with the new version.
6. _Commit and Push_: Commit the changes and push the release branch to the remote repository.
7. _Build Library_: Build the library using the command `yarn prepare` to generate the necessary files for deployment.

_The following steps may vary depending on your local environment:_

8. _Disable npmrc_: Remove or rename the `.npmrc` file in the root directory of the project
9. _Publish to npm_: Run `npm publish --access public` in the root directory of the project to publish the package to npm registry.
10. _Verify NPM Package_: Verify that the package has been published successfully by checking [the NPM page](https://www.npmjs.com/package/@flyreel/flyreel-sdk-react-native?activeTab=versions)
11. _Enable npmrc_: Restore the `.npmrc` file in the root directory of the project
12. _Publish to Github_ Run `npm publish --access public` in the root directory of the project to publish the package to Github Packages.
13. _Verify Github Package_: Verify that the package has been published successfully by checking [the Github Packages page](https://github.com/Flyreel/flyreel-sdk-react-native/pkgs/npm/flyreel-sdk-react-native/versions)
