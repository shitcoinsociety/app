export const socialNetworks = {
  github: { label: "GitHub", icon: "i-simple-icons:github", url: (handle) => `https://github.com/${handle}` },
  facebook: { label: "Facebook", icon: "i-simple-icons:facebook", url: (handle) => `https://facebook.com/${handle}` },
  instagram: { label: "Instagram", icon: "i-simple-icons:instagram", url: (handle) => `https://instagram.com/${handle}` },
  x: { label: "X", icon: "i-simple-icons:x", url: (handle) => `https://x.com/${handle}` }
};

export function socialLinksFor(user) {
  return Object.entries(user.social_links ?? {})
    .filter(([key, value]) => socialNetworks[key] && value)
    .map(([key, value]) => {
      const { label, icon, url } = socialNetworks[key];
      const href = /^https?:\/\//i.test(value) ? value : url(value);

      return { key, label, icon, href };
    });
}
