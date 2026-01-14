# Fall River Lake Rentals - 2026 Social Media Content Calendar

This Python script generates a comprehensive year-long social media content calendar for Fall River Lake Rentals in Fall River, Kansas, and uploads it to Airtable.

## Features

- **365+ Days of Content**: Complete 2026 calendar with multiple posts per week
- **Event-Based Content**: Includes local events like Fall River Star Party at Casner Creek
- **Hunting Season Coverage**: All Kansas hunting seasons (deer, turkey, waterfowl)
- **Fishing Content**: Seasonal fishing tips and species-specific content
- **Activities & Attractions**: Hiking, boating, wildlife viewing, and more
- **Seasonal Themes**: Holiday content, seasonal promotions, and timely posts
- **Multiple Platforms**: Content optimized for Facebook, Instagram, Reels, and Stories
- **Airtable Integration**: Automatically uploads to your Airtable base

## Content Categories

- Hunting (deer, turkey, waterfowl)
- Fishing (bass, crappie, catfish, white bass, walleye)
- Seasonal/Holiday posts
- Promotional offers
- Local events (Star Party, etc.)
- Activities (hiking, boating, canoeing, water sports)
- Wildlife viewing
- Testimonials
- Scenic/lifestyle content

## Based on Real Data

Content calendar includes:
- **Kansas Hunting Seasons 2025-2026**:
  - Youth & Disability Deer: Sept 6-14, 2025
  - Archery Deer: Sept 15 - Dec 31, 2025
  - Muzzleloader: Sept 15-28, 2025
  - Pre-Rut Whitetail: Oct 11-13, 2025
  - Spring Turkey: April 16 - May 31, 2026
  - Fall Turkey: Oct 1, 2025 - Jan 31, 2026
  - Waterfowl (Goose): Nov 1 - Jan 4, Jan 24 - Feb 15
  - Early Teal: Sept 13-28, 2025

- **Fall River Lake Attractions**:
  - 2,450-acre lake
  - 6 hiking trails at Casner Creek
  - Excellent fishing (bass, crappie, catfish, white bass, walleye)
  - Water sports (skiing, jet skiing, swimming)
  - Wildlife viewing (eagles, deer, turkeys, diverse bird species)
  - 10,900-acre Game Management Area

- **Annual Events**:
  - Fall River Star Party at Casner Creek Campground
  - Seasonal migrations and wildlife viewing opportunities

## Installation

1. **Install Python dependencies:**
```bash
pip install -r requirements.txt
```

2. **Set up Airtable** (Optional - script will create JSON file if not configured):

   a. Create an Airtable account at https://airtable.com

   b. Create a new base for your social media calendar

   c. Create a table named exactly: `Social Media Content Calendar 2026`

   d. Add the following fields to your table:
      - Date (Date field)
      - Platform (Single line text)
      - Content Type (Single select: Post, Reel, Story Series)
      - Caption (Long text)
      - Hashtags (Long text)
      - Media Suggestion (Long text)
      - Category (Single select)
      - Call to Action (Single line text)

   e. Get your API credentials:
      - Go to https://airtable.com/account
      - Generate a personal access token
      - Find your Base ID (in the URL when viewing your base: `https://airtable.com/appXXXXXXXXXX/...`)

3. **Set environment variables:**
```bash
export AIRTABLE_API_KEY='your_api_key_here'
export AIRTABLE_BASE_ID='your_base_id_here'
```

Or add to your `~/.bashrc` or `~/.zshrc`:
```bash
echo 'export AIRTABLE_API_KEY="your_api_key_here"' >> ~/.bashrc
echo 'export AIRTABLE_BASE_ID="your_base_id_here"' >> ~/.bashrc
source ~/.bashrc
```

## Usage

### Run the script:
```bash
python3 social_media_calendar.py
```

### Output Options:

1. **With Airtable configured**: Uploads all content directly to your Airtable base
2. **Without Airtable**: Creates `fall_river_content_calendar_2026.json` file that you can:
   - Import into Airtable manually
   - Import into Google Sheets
   - Use with other scheduling tools (Hootsuite, Buffer, etc.)

## Content Structure

Each post includes:
- **Date**: Specific posting date in 2026
- **Platform**: Facebook, Instagram, or both
- **Content Type**: Post, Reel, or Story Series
- **Caption**: Ready-to-post caption
- **Hashtags**: Relevant, researched hashtags
- **Media Suggestion**: What photo/video to use
- **Category**: Content classification
- **Call to Action**: Engagement prompt

## Customization

To customize the content:

1. Edit `social_media_calendar.py`
2. Modify the `create_content_calendar()` function
3. Add, remove, or edit posts in each month's section
4. Update hashtags, captions, or dates as needed
5. Run the script again to regenerate

## Tips for Best Results

1. **Images**: Collect photos matching the "Media Suggestion" for each post
2. **Scheduling**: Use a tool like Hootsuite, Buffer, or Later to schedule in advance
3. **Engagement**: Monitor comments and respond promptly
4. **Flexibility**: Adjust dates based on actual event confirmations
5. **Analytics**: Track which content performs best and adjust future content

## Event Updates

Some events (like the Fall River Star Party) don't have 2026 dates confirmed yet. Update these once announced:
- Check Kansas Department of Wildlife & Parks: https://ksoutdoors.gov
- Fall River State Park: 620-637-2213
- Update the script with confirmed dates

## Sources & References

- [Kansas Hunting Seasons Guide](https://huntinglocator.com/blog/kansas-hunting-seasons/)
- [KDWP Fall River State Park](https://ksoutdoors.gov/State-Parks/Locations/Fall-River)
- [Fall River Star Party Information](https://ksoutdoors.gov/State-Parks/Locations/Fall-River/Fall-River-Calendar)
- [Fall River Fishing Information](https://ksoutdoors.gov/Fishing/Where-to-Fish-in-Kansas/Fishing-Locations-Public-Waters/Fishing-in-Southeast-Kansas/Fall-River-Reservoir)

## Support

For questions or issues:
1. Check that Python 3.6+ is installed: `python3 --version`
2. Verify dependencies are installed: `pip list | grep requests`
3. Check environment variables: `echo $AIRTABLE_API_KEY`
4. Review Airtable table name and field names match exactly

## License

This content calendar was created specifically for Fall River Lake Rentals. Customize and use as needed for your business.

---

**Generated**: January 2026
**Content Period**: January 1, 2026 - December 31, 2026
**Total Posts**: 100+ posts across all categories
