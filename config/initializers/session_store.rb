# Defaults already give the session cookie http-only + SameSite=Lax
# This just names the cookie, sets a 14-day expiry (without it cookie dies
# on browser close), and forces Scure in production
Rails.application.config.session_store :cookie_store,
  key:  "_sg_session",
  same_site: :lax,
  secure: Rails.env.production?,
  expire_after: 14.days
