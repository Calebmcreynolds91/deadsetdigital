import React, { useState } from 'react';
import { Copy, CheckCircle, AlertCircle, Loader2 } from 'lucide-react';

export default function ReviewResponseGenerator() {
  const [reviewText, setReviewText] = useState('');
  const [businessName, setBusinessName] = useState('');
  const [industry, setIndustry] = useState('');
  const [starRating, setStarRating] = useState(5);
  const [loading, setLoading] = useState(false);
  const [responses, setResponses] = useState([]);
  const [error, setError] = useState('');
  const [copiedIndex, setCopiedIndex] = useState(null);

  const generateResponses = async () => {
    if (!reviewText.trim() || !businessName.trim() || !industry.trim() || !starRating) {
      setError('Please fill in all fields');
      return;
    }

    setLoading(true);
    setError('');
    setResponses([]);

    try {
      const response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'claude-sonnet-4-20250514',
          max_tokens: 2000,
          messages: [
            {
              role: 'user',
              content: `You are helping a business owner respond to a Google review. Generate 3 DIFFERENT review responses that are:

- Genuinely human-sounding (absolutely no AI-like language, no corporate speak, no phrases like "we strive" or "we're committed")
- Natural and conversational, like a real person wrote it
- SEO-friendly with 2-3 relevant keywords naturally woven in (never forced or obvious)
- Google-compliant (professional, addresses the review, no promotional links)
- Appropriate length (50-150 words)
- Each response should have a different tone or approach (grateful, detailed, warm, etc.)
- TONE SHOULD MATCH THE STAR RATING: ${starRating}-star reviews need appropriate responses (grateful for 4-5 stars, understanding/apologetic for 1-3 stars)

Business Name: ${businessName}
Industry: ${industry}
Star Rating: ${starRating} out of 5 stars
Customer Review: "${reviewText}"

CRITICAL INSTRUCTIONS:
- Write like a real human business owner, not a corporate robot
- Use contractions (we're, you're, it's) and natural language
- Vary sentence structure - mix short and longer sentences
- Include specific details from their review when possible
- NO phrases like: "we strive to", "we pride ourselves", "rest assured", "we appreciate your feedback"
- NO excessive enthusiasm or exclamation marks
- For negative reviews (1-3 stars): be genuinely apologetic and offer to make it right, without being defensive
- For positive reviews (4-5 stars): be warm and grateful without being over-the-top
- Each response should feel distinctly different from the others
- Naturally include 2-3 industry-relevant keywords without making it obvious

Return ONLY a valid JSON object in this exact format (no other text, no markdown, no backticks):
{
  "response1": "first response text here",
  "response2": "second response text here",
  "response3": "third response text here"
}

DO NOT include anything other than the JSON object. NO backticks, NO markdown, NO explanations.`
            }
          ]
        })
      });

      const data = await response.json();
      let responseText = data.content[0].text;

      // Strip any markdown formatting
      responseText = responseText.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();

      const parsed = JSON.parse(responseText);

      setResponses([
        { text: parsed.response1, label: 'Option 1' },
        { text: parsed.response2, label: 'Option 2' },
        { text: parsed.response3, label: 'Option 3' }
      ]);
    } catch (err) {
      setError('Failed to generate responses. Please try again.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const copyToClipboard = async (text, index) => {
    try {
      await navigator.clipboard.writeText(text);
      setCopiedIndex(index);
      setTimeout(() => setCopiedIndex(null), 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-white to-orange-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900 transition-colors duration-300">
      <div className="max-w-4xl mx-auto px-4 py-12">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="inline-block mb-4">
            <div className="text-5xl">⭐</div>
          </div>
          <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-3">
            Review Response Generator
          </h1>
          <p className="text-gray-600 dark:text-gray-300 text-lg">
            Generate authentic, SEO-optimized responses to your Google reviews
          </p>
        </div>

        {/* Input Form */}
        <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-8 mb-8 transition-colors duration-300">
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-2">
                Business Name
              </label>
              <input
                type="text"
                value={businessName}
                onChange={(e) => setBusinessName(e.target.value)}
                placeholder="e.g., Joe's Coffee Shop"
                className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent bg-white dark:bg-gray-700 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 transition-colors duration-300"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-2">
                Industry/Business Type
              </label>
              <input
                type="text"
                value={industry}
                onChange={(e) => setIndustry(e.target.value)}
                placeholder="e.g., Coffee Shop, HVAC, Law Firm, etc."
                className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent bg-white dark:bg-gray-700 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 transition-colors duration-300"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-3">
                Star Rating
              </label>
              <div className="flex gap-2">
                {[1, 2, 3, 4, 5].map((rating) => (
                  <button
                    key={rating}
                    type="button"
                    onClick={() => setStarRating(rating)}
                    className={`flex-1 py-3 px-4 rounded-lg font-semibold transition-all ${
                      starRating === rating
                        ? 'bg-orange-500 text-white shadow-lg scale-105'
                        : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-600'
                    }`}
                  >
                    {rating} ⭐
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-2">
                Customer Review
              </label>
              <textarea
                value={reviewText}
                onChange={(e) => setReviewText(e.target.value)}
                placeholder="Paste the customer's Google review here..."
                rows={6}
                className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent resize-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 transition-colors duration-300"
              />
            </div>

            {error && (
              <div className="flex items-center gap-2 text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/30 p-4 rounded-lg">
                <AlertCircle size={20} />
                <span>{error}</span>
              </div>
            )}

            <button
              onClick={generateResponses}
              disabled={loading}
              className="w-full bg-gradient-to-r from-orange-500 to-orange-600 text-white font-semibold py-4 rounded-lg hover:from-orange-600 hover:to-orange-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <Loader2 className="animate-spin" size={20} />
                  Generating Responses...
                </>
              ) : (
                'Generate Responses'
              )}
            </button>
          </div>
        </div>

        {/* Generated Responses */}
        {responses.length > 0 && (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
              Your Response Options
            </h2>

            {responses.map((response, index) => (
              <div
                key={index}
                className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 hover:shadow-xl transition-all duration-300"
              >
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {response.label}
                  </h3>
                  <button
                    onClick={() => copyToClipboard(response.text, index)}
                    className="flex items-center gap-2 px-4 py-2 bg-orange-100 dark:bg-orange-900/30 text-orange-700 dark:text-orange-400 rounded-lg hover:bg-orange-200 dark:hover:bg-orange-900/50 transition-colors"
                  >
                    {copiedIndex === index ? (
                      <>
                        <CheckCircle size={18} />
                        Copied!
                      </>
                    ) : (
                      <>
                        <Copy size={18} />
                        Copy
                      </>
                    )}
                  </button>
                </div>

                <p className="text-gray-700 dark:text-gray-300 leading-relaxed whitespace-pre-wrap">
                  {response.text}
                </p>
              </div>
            ))}
          </div>
        )}

        {/* Footer Info */}
        <div className="mt-12 text-center text-sm text-gray-500 dark:text-gray-400">
          <p>💡 Tip: Choose the response that best matches your brand voice, then personalize it if needed</p>
        </div>
      </div>
    </div>
  );
}
