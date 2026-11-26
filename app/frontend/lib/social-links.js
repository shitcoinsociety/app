const HTTP_URL = /^https?:\/\//i;
const OTHER_SCHEME = /^[a-z][a-z0-9+.-]*:/i;

function handleNetwork(label, icon, baseUrl) {
  return {
    label,
    icon,
    href: (value) => (HTTP_URL.test(value) ? value : `${baseUrl}${value}`)
  };
}

// A website may be given as a full URL or a bare host such as "example.com".
function websiteHref(value) {
  const trimmed = value.trim();
  if (!trimmed) return null;
  if (HTTP_URL.test(trimmed)) return trimmed;
  // Reject other schemes (e.g. "javascript:") instead of rendering them as links.
  if (OTHER_SCHEME.test(trimmed)) return null;

  return `https://${trimmed.replace(/^\/\//, "")}`;
}

export const socialNetworks = {
  github: handleNetwork("GitHub", "i-simple-icons:github", "https://github.com/"),
  facebook: handleNetwork("Facebook", "i-simple-icons:facebook", "https://facebook.com/"),
  instagram: handleNetwork("Instagram", "i-simple-icons:instagram", "https://instagram.com/"),
  x: handleNetwork("X", "i-simple-icons:x", "https://x.com/"),
  website: { label: "Website", icon: "i-lucide:globe", href: websiteHref }
};

export function socialLinksFor(user) {
  return Object.entries(user.social_links ?? {})
    .filter(([key, value]) => socialNetworks[key] && value)
    .map(([key, value]) => {
      const { label, icon, href } = socialNetworks[key];

      return { key, label, icon, href: href(value) };
    })
    .filter((link) => link.href);
}
