module.exports = ({ env }) => ({
  upload: {
    provider: 'local',
    providerOptions: {
      sizeLimit: 1000000, // 1MB
    },
  },
  email: {
    provider: 'sendmail',
    settings: {
      defaultFrom: 'no-reply@example.com',
      defaultReplyTo: 'no-reply@example.com',
    },
  },
});
