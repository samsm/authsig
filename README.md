# AuthSig

An idea for decentralized identification and authorization.

## Installation

It's a Padrino (rack) app.
`padrino start` should work.
So should `foreman start`.

`rake db:migrate` first, maybe?
And `rake db:seed` too, perhaps.

## Secret

### Should be noted: there is a static "secret" the app right now. This is not really a secret at all, so the system should not be considered secure at all.

I'm still figuring out how to deal with secrets. I think there's a fairly coherent approach right around the corner.
