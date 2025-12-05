# Contributing

Pull requests are welcome!

## Before Opening a PR

Please ensure the following checks pass:

1. Tests are passing:
   ```bash
   bazelisk test //...
   ```

2. Formatting is correct:
   ```bash
   bazelisk run :fmt
   ```

3. Lints are passing:
   ```bash
   bazelisk run :lint
   ```

## Documentation

If new APIs are introduced, they must be documented.

If documentation changes, regenerate the docs in a separate commit:
```bash
bazelisk run //docs:update
```

## PR Guidelines

PR title will be included in the changelog, so make sure it clearly communicates the change.

PR body should communicate the intent of the change - what it does and why.
