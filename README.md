# AuthSig

An idea for decentralized identification and authorization.

## Installation

It's a Padrino (rack) app.
`padrino start` should work.
So should `foreman start`.

`rake db:migrate` first, maybe?
And `rake db:seed` too, perhaps.

Set an AUTHSIG_HOUSE_SECRET environment variable.
Adding AUTHSIG_HOUSE_SECRET=abcdefg-some-secret-here to `.env` is a good way to accomplish this in development mode.

The site root provides a lot of info about how stuff works.

Here's a hosted version: http://authsig.herokuapp.com/
