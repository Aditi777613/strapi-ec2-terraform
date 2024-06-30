module.exports = ({ env }) => ({
  settings: {
    logger: {
      level: 'info',
      exposeInContext: true,
      requests: true,
    },
    parser: {
      enabled: true,
      multipart: true,
      jsonLimit: '5mb',
    },
  },
});
