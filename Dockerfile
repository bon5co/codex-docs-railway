# CodeX Docs for Railway.
# Upstream (codex-team/codex.docs v2.3.3) reads every setting, including the admin password and the JWT secret, from a
# YAML file, so there is no environment variable to set. This wrapper writes that file at boot from DOCS_PASSWORD and
# DOCS_SECRET, binds the port Railway injects, and keeps the database and uploads under one directory (/data) so a
# single volume holds them. It also makes the write API answer 401 JSON instead of redirecting to the login page, so a
# client that is not logged in gets a refusal it can read.
FROM ghcr.io/codex-team/codex.docs:v2.3.3@sha256:c19cdeb3398d704a43760be24c287774f222ed7b882444fa207124a614ddd7ea

RUN grep -q "res.redirect('/auth');" dist/backend/routes/middlewares/locals.js \
 && sed -i "s#res.redirect('/auth');#if (req.originalUrl.startsWith('/api/')) { res.status(401).json({ success: false, error: 'authentication required' }); } else { res.redirect('/auth'); }#" dist/backend/routes/middlewares/locals.js \
 && grep -q "status(401)" dist/backend/routes/middlewares/locals.js

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["node", "dist/backend/app.js"]
