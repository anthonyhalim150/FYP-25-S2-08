import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

function CleanerProfile() {
  const { id } = useParams(); 
  const [cleaner, setCleaner] = useState(null);

  useEffect(() => {

    const fakeCleaner = {
      id,
      name: 'Maria Lopez',
      bio: 'Experienced cleaner specializing in deep cleans and move-outs.',
      services: [
        { name: 'Deep Clean', price: '$100' },
        { name: 'Move-Out Clean', price: '$150' },
      ],
      stats: {
        views: 34,
        shortlisted: 12,
      },
    };

    setCleaner(fakeCleaner);
  }, [id]);

  if (!cleaner) return <div>Loading...</div>;

  return (
    <div style={{ padding: '2rem' }}>
      <h2>{cleaner.name}</h2>
      <p>{cleaner.bio}</p>

      <h3>Services Offered</h3>
      <ul>
        {cleaner.services.map((service, index) => (
          <li key={index}>
            {service.name} — <strong>{service.price}</strong>
          </li>
        ))}
      </ul>

      <h3>Stats</h3>
      <p>Views: {cleaner.stats.views}</p>
      <p>Shortlisted: {cleaner.stats.shortlisted}</p>
    </div>
  );
}

export default CleanerProfile;
