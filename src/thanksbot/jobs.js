import Scheduler from '../lib/scheduler';
import {generate, prettyDate} from './lib/digest';
import {query} from '../lib/db';
import email from '../lib/email';

const scheduler = new Scheduler();
export default scheduler;

scheduler.add('0 7 * * 1', function() {
  query('thanks_log').then(generate).then(digest => {
    return email({
      from: 'ThanksBot <coop+thanksbot@bocoup.com>',
      to: 'Everybody <coop@bocoup.com>',
      subject: `ThanksBot Weekly: ${prettyDate()}`,
      message: `<pre>${digest}</pre>`,
      altText: digest,
    });
  });
});
