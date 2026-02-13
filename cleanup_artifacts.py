#!/usr/bin/env python3
"""
GitHub Actions Artifacts Cleanup Script
Deletes artifacts older than 30 days from GitHub repositories
"""

import os
import sys
import requests
from datetime import datetime, timedelta
import argparse
import time

class GitHubArtifactCleaner:
    def __init__(self, token, owner, repo):
        self.token = token
        self.owner = owner
        self.repo = repo
        self.base_url = "https://api.github.com"
        self.headers = {
            "Authorization": f"token {token}",
            "Accept": "application/vnd.github.v3+json",
            "User-Agent": "GitHub-Artifacts-Cleaner"
        }
        self.cutoff_date = datetime.now() - timedelta(days=7)
    
    def get_artifacts(self, page=1, per_page=100):
        """Get list of artifacts from the repository"""
        url = f"{self.base_url}/repos/{self.owner}/{self.repo}/actions/artifacts"
        params = {
            "page": page,
            "per_page": per_page
        }
        
        try:
            response = requests.get(url, headers=self.headers, params=params)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error fetching artifacts: {e}")
            return None
    
    def delete_artifact(self, artifact_id):
        """Delete a specific artifact"""
        url = f"{self.base_url}/repos/{self.owner}/{self.repo}/actions/artifacts/{artifact_id}"
        
        try:
            response = requests.delete(url, headers=self.headers)
            response.raise_for_status()
            return True
        except requests.exceptions.RequestException as e:
            print(f"Error deleting artifact {artifact_id}: {e}")
            return False
    
    def is_artifact_old(self, created_at):
        """Check if artifact is older than 30 days"""
        artifact_date = datetime.strptime(created_at, "%Y-%m-%dT%H:%M:%SZ")
        return artifact_date < self.cutoff_date
    
    def cleanup_artifacts(self, dry_run=False):
        """Main cleanup function"""
        print(f"Starting cleanup for {self.owner}/{self.repo}")
        print(f"Cutoff date: {self.cutoff_date.strftime('%Y-%m-%d %H:%M:%S')}")
        
        if dry_run:
            print("DRY RUN MODE - No artifacts will be deleted")
        
        total_deleted = 0
        total_size_saved = 0
        page = 1
        
        while True:
            print(f"Fetching page {page}...")
            data = self.get_artifacts(page=page)
            
            if not data or not data.get('artifacts'):
                break
            
            artifacts = data['artifacts']
            
            for artifact in artifacts:
                artifact_id = artifact['id']
                name = artifact['name']
                created_at = artifact['created_at']
                size_bytes = artifact['size_in_bytes']
                
                if self.is_artifact_old(created_at):
                    print(f"Found old artifact: {name} (ID: {artifact_id}) - Created: {created_at} - Size: {size_bytes} bytes")
                    
                    if not dry_run:
                        if self.delete_artifact(artifact_id):
                            print(f"✓ Deleted artifact: {name}")
                            total_deleted += 1
                            total_size_saved += size_bytes
                            # Rate limiting - GitHub allows 5000 requests per hour
                            time.sleep(0.1)
                        else:
                            print(f"✗ Failed to delete artifact: {name}")
                    else:
                        print(f"Would delete artifact: {name}")
                        total_deleted += 1
                        total_size_saved += size_bytes
            
            # Check if there are more pages
            if len(artifacts) < 100:
                break
            
            page += 1
        
        print(f"\nCleanup completed!")
        print(f"Artifacts processed: {total_deleted}")
        print(f"Storage saved: {self.format_bytes(total_size_saved)}")
    
    def format_bytes(self, bytes_size):
        """Convert bytes to human readable format"""
        for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
            if bytes_size < 1024.0:
                return f"{bytes_size:.2f} {unit}"
            bytes_size /= 1024.0
        return f"{bytes_size:.2f} PB"

def main():
    parser = argparse.ArgumentParser(description="Clean up old GitHub Actions artifacts")
    parser.add_argument("--token", required=True, help="GitHub personal access token")
    parser.add_argument("--owner", required=True, help="Repository owner (username or organization)")
    parser.add_argument("--repo", required=True, help="Repository name")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be deleted without actually deleting")
    
    args = parser.parse_args()
    
    # Validate token
    if not args.token or len(args.token) < 10:
        print("Error: Please provide a valid GitHub token")
        sys.exit(1)
    
    cleaner = GitHubArtifactCleaner(args.token, args.owner, args.repo)
    
    try:
        cleaner.cleanup_artifacts(dry_run=args.dry_run)
    except KeyboardInterrupt:
        print("\nOperation cancelled by user")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()